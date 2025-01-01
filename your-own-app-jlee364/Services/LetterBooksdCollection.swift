import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore

enum CollectionServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class LetterBooksdCollection: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var error: Error?
    
    func createCollection(collection: BookCollection) async throws -> String {
        // addDocument is one of those “odd” methods.
        let ref = try await db.collection("bookcollections").addDocument(data: [
            "id": collection.id,
            "user": collection.user,
            "name": collection.name,
            "bookIds": collection.bookIds
        ])
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref.documentID
    }
    
    func updateCollection(collection: BookCollection, name: String, bookIds: Array<String>) async throws -> String {
        let collectionID = collection.id
        let ref = db.collection("bookcollections").document(collectionID)
        
        try await ref.updateData([
            "name": name,
            "bookIds": bookIds
        ])
        
        return ref.documentID
    }
    
    func removeCollection(collectionID: String) async throws {
        let ref = db.collection("bookcollections").document(collectionID)
        do {
            try await ref.delete()
            print("Successfully deleted!")
        }
        catch {
            print("Error deleting book collection.")
        }
    }
    
    func fetchCollections() async throws -> [BookCollection] {
        let collectionQuery = db.collection("bookcollections")
            .limit(to: PAGE_LIMIT)
        
        print("Got through collection query!")
        
        let querySnapshot = try await collectionQuery.getDocuments()
        
        print("Got query snapshot!")
        
        return try querySnapshot.documents.map {
            print("\($0.documentID) => \($0.data())")

            guard let bookIds = $0.get("bookIds") as? Array<String>,
                  let user = $0.get("user") as? String,
                  let name = $0.get("name") as? String else {
                throw CollectionServiceError.mismatchedDocumentError
            }
            
            return BookCollection(
                id: $0.documentID,
                user: user,
                name: name,
                bookIds: bookIds
            )
        }
    }
}

