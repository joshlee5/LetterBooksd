import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore

let COLLECTION_NAME = "reviews"
let PAGE_LIMIT = 20

enum ReviewServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class LetterBooksdReview: ObservableObject {
    private let db = Firestore.firestore()
    
    // Some of the iOS Firebase library’s methods are currently a little…odd.
    // They execute synchronously to return an initial result, but will then
    // attempt to write to the database across the network asynchronously but
    // not in a way that can be checked via try async/await. Instead, a
    // callback function is invoked containing an error _if it happened_.
    // They are almost like functions that return two results, one synchronously
    // and another asynchronously.
    //
    // To deal with this, we have a published variable called `error` which gets
    // set if a callback function comes back with an error. SwiftUI views can
    // access this error and it will update if things change.
    @Published var error: Error?
    
    func createReview(review: Review) async throws -> String {
        // addDocument is one of those “odd” methods.
        let ref = try await db.collection(COLLECTION_NAME).addDocument(data: [
            "id": review.id,
            "title": review.title,
            "user": review.user,
            "date": review.date, // This gets converted into a Firestore Timestamp.
            "rating": review.rating,
            "body": review.body,
        ])
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref.documentID
    }
    
    func updateReview(review: Review, title: String, rating: String, body: String) async throws -> String {
        let reviewID = review.id
        let ref = db.collection(COLLECTION_NAME).document(reviewID)
        
        try await ref.updateData([
                "title": title,
                "rating": rating,
                "body": body
                // user, date, and id do not get updated since it only edits title and body with everything else intact
            ])
        
        return ref.documentID
    }
    
    func removeReview(reviewID: String) async throws {
        let ref = db.collection(COLLECTION_NAME).document(reviewID)
        do {
            try await ref.delete()
            print("Successfully deleted!")
        }
        catch {
            print("Error deleting review.")
        }
        
    }
    
    // Note: This is quite unsophisticated! It only gets the first PAGE_LIMIT articles.
    // In a real app, you implement pagination.
    func fetchReviews() async throws -> [Review] {
        let reviewQuery = db.collection(COLLECTION_NAME)
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)
        
        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await reviewQuery.getDocuments()
        
        return try querySnapshot.documents.map {
            print("\($0.documentID) => \($0.data())")
            
            // This is likely new Swift for you: type conversion is conditional, so they
            // must be guarded in case they fail.
            guard let title = $0.get("title") as? String,
                  let user = $0.get("user") as? String,
                    // Firestore returns Swift Dates as its own Timestamp data type.
                  let dateAsTimestamp = $0.get("date") as? Timestamp,
                  let rating = $0.get("rating") as? String,
                  let body = $0.get("body") as? String else {
                throw ReviewServiceError.mismatchedDocumentError
            }
            
            return Review(
                id: $0.documentID,
                title: title,
                user: user,
                date: dateAsTimestamp.dateValue(),
                rating: rating,
                body: body
            )
        }
    }
        
    func searchReviews(query: String) async throws -> [Review] {
        // searchQuery has to match the exact capitalization and spacing of the article title.
        let searchQuery = query
        
        let querySnapshot = try await db.collection(COLLECTION_NAME)
        // Wrote below code with some help from ChatGPT
            .whereField("title", isGreaterThanOrEqualTo: searchQuery)
            .whereField("title", isLessThanOrEqualTo: "\(searchQuery)\u{f8ff}")
                    .getDocuments()
        
        return querySnapshot.documents.compactMap { document -> Review? in
                try? document.data(as: Review.self)
            }
    }
}
