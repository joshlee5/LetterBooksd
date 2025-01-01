import SwiftUI

struct BookCollectionEdit: View {
    @EnvironmentObject var collectionService: LetterBooksdCollection

    @Binding var collections: [BookCollection]
    @Binding var writing: Bool

    @State var name = ""
    @State var bookIds: [String] = [""]
    
    var collection: BookCollection
    
    func editCollection() async {
        Task {
            do {
                let collectionId = try await collectionService.updateCollection(collection: collection, name: name, bookIds: bookIds)
                writing = false
                if let index = collections.firstIndex(where: { $0.id == collectionId }) {
                    collections[index] = BookCollection(id: collectionId, user: collection.user, name: collection.name, bookIds: collection.bookIds)
                    }
            } catch {
                print("Book Collection edited successfully.")
            }
        }
    }

    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("Name")) {
                        TextField("", text: $name)
                    }
                    
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
                .navigationTitle("Edit Current collection")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                await editCollection()
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
