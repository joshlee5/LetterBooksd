import SwiftUI

struct BookCollectionEntry: View {
    @EnvironmentObject var collectionService: LetterBooksdCollection

    @Binding var collections: [BookCollection]
    @Binding var writing: Bool
    
    @State var user: String
    @State var name = ""
    @State var bookIds: [String] = [""]
    

    func submitcollection() async {
        // We take a two-part approach here: this first part sends the article to
        // the database. The `createArticle` function gives us its ID.
        Task {
            do {
                let collectionId = try await collectionService.createCollection(collection: BookCollection(
                    id: UUID().uuidString,
                    user: user,
                    name: name,
                    bookIds: bookIds
                ))
                
                collections.append(BookCollection(
                    id: collectionId,
                    user: user,
                    name: name,
                    bookIds: bookIds
                ))

                writing = false
            } catch {
             print("Error has occurred.")
            }
        }
    }

    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("Name")) {
                        TextField("", text: $name)
                    }
                    
                    // Way to create list of book ids?
                    Section(header: Text("Input Book IDs here")) {
                        ForEach ($bookIds, id: \.self) { $bookId in
                            TextField("Enter book id", text: $bookId)
                        }
                        
                        Button(action: addBookId) {
                            Text("Add Another Book ID")
                                .foregroundColor(.green)
                        }
                    }
                }
                .navigationTitle("Create your book collection!")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Create") {
                            Task {
                                await submitcollection()
                            }
                        }
                        .disabled(name.isEmpty)
                    }
                }
            }
        }

    func addBookId() {
        bookIds.append("")
    }
}

//#Preview {
//    BookCollectionEntry()
//}
