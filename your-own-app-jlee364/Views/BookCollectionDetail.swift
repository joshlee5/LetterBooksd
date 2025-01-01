import SwiftUI

struct BookCollectionDetail: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var collectionService: LetterBooksdCollection
    @Binding var collections: [BookCollection]
    @State private var isEditing = false
    @State private var isBodyVisible = false
    @State private var error: Error?
    
    var collection: BookCollection
    
    func deleteCollection (current_collection: BookCollection) async {
        let collectionId = current_collection.id
        
        Task {
            do {
                if let index = collections.firstIndex(where: { $0.id == collectionId }) {
                                collections.remove(at: index)
                    }
                
                try await collectionService.removeCollection(collectionID: collectionId)
            }
            catch {
                print("Deletion unsuccessful")
            }
        }
    }
    
    func getUser() -> String {
        do {
            let userID = try auth.getUID()
            return userID
        }
        catch {
            self.error = error
            print("Error: Could not get User ID.")
        }
        return ""
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(collection.name)
                    .padding()
                    .bold()
                    .font(.headline)
                
                Text(collection.user)
                    .padding()
                    .font(.subheadline)
                    .underline()
                
                ForEach(collection.bookIds, id: \.self) { bookId in
                    Text(bookId)
                        .padding()
                }

                if (self.getUser() == collection.user)
                {
                    HStack () {
                        Button("Delete") {
                            Task {
                                await deleteCollection(current_collection: collection)
                            }
                        }
                        .padding()
                        .background(Color(.red))
                        .border(Color(.black))
                        Divider()
                        NavigationLink(destination: BookCollectionEdit(collections: $collections, writing: $isEditing, collection: collection), isActive: $isEditing) {
                                EmptyView()
                            }
                            Button("Edit") {
                                isEditing = true
                            }
                            .padding()
                            .background(Color(.yellow))
                            .border(Color(.black))
                    }
                    .background(Color(.lightGray))
                }
            }
        }
    }
}

//#Preview {
//    BookCollectionDetail()
//}
