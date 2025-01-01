import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore

enum CommentServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class LetterBooksdComment: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var error: Error?
    
    func createComment(comment: Comment) async throws -> String {
        // addDocument is one of those “odd” methods.
        let ref = try await db.collection("comments").addDocument(data: [
            "reviewId": comment.reviewId,
            "id": comment.id,
            "user": comment.user,
            "date": comment.date, // This gets converted into a Firestore Timestamp.
            "body": comment.body
        ])
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref.documentID
    }
    
    func updateComment(comment: Comment, body: String) async throws -> String {
        let commentID = comment.id
        let ref = db.collection("comments").document(commentID)
        
        try await ref.updateData([
            "body": body
            // user, date, and id do not get updated since it only edits title and body with everything else intact
        ])
        
        return ref.documentID
    }
    
    func removeComment(commentID: String) async throws {
        let ref = db.collection("comments").document(commentID)
        do {
            try await ref.delete()
            print("Successfully deleted!")
        }
        catch {
            print("Error deleting comment.")
        }
        
    }
    
    func fetchComments() async throws -> [Comment] {
        let commentQuery = db.collection("comments")
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)
        
        let querySnapshot = try await commentQuery.getDocuments()
        
        return try querySnapshot.documents.map {
            print("\($0.documentID) => \($0.data())")
            
            guard let reviewId = $0.get("reviewId") as? String,
                  let user = $0.get("user") as? String,
                  let dateAsTimestamp = $0.get("date") as? Timestamp,
                  let body = $0.get("body") as? String else {
                throw ReviewServiceError.mismatchedDocumentError
            }
            
            return Comment(
                reviewId: reviewId,
                id: $0.documentID,
                user: user,
                date: dateAsTimestamp.dateValue(),
                body: body
            )
        }
    }
}

