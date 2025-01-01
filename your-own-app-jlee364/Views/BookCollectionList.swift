import SwiftUI

struct BookCollectionList: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var collectionService: LetterBooksdCollection

    @State var collections: [BookCollection]
    @State var user: String
    @State var error: Error?
    @State var fetching = false
    @State var writing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if fetching {
                    ProgressView()
                } else if error != nil {
                    Text("Something went wrong…we wish we can say more 🤷🏽")
                } else if collections.count == 0 {
                    VStack {
                        Spacer()
                        Text("No book collections created yet!")
                        Spacer()
                    }
                } else {
                    List(collections) { collection in
                        NavigationLink {
                            BookCollectionDetail(collections: $collections, collection: collection)
                        } label: {
                            BookCollectionMetadata(collection: collection)
                        }
                    }
                }
            }
            .navigationTitle("Book Collections")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("Create Your Collection!") {
                            writing = true
                        }
                        .background(Color(.green))
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $writing) {
                BookCollectionEntry(collections: $collections, writing: $writing, user: user)
            }
            .task {
                fetching = true

                do {
                    // This line is not working
                    collections = try await collectionService.fetchCollections()
                    // Showing up as empty
                    print(collections)
                    fetching = false
                } catch {
                    self.error = error
                    fetching = false
                }
            }
        }
        .background(.blue)
    }
}

//struct BookCollectionList_Previews: PreviewProvider {
//
//    static var previews: some View {
//        BookCollectionList(collections: [])
//            .environmentObject(LetterBooksdAuth())
//
//        BookCollectionList(collections: [
//            BookCollection(
//                id: "12345",
//                title: "Pcollection",
//                user: "Anonymous",
//                date: Date(),
//                rating: "5",
//                body: "Lorem ipsum dolor sit something something amet"
//            ),
//
//            BookCollection(
//                id: "67890",
//                title: "Some time ago",
//                user: "Anonymous",
//                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
//                rating: "5",
//                body: "Duis diam ipsum, efficitur sit amet something somesit amet"
//            )
//        ])
//        .environmentObject(LetterBooksdAuth())
//        .environmentObject(LetterBooksdCollection())
//    }
//}
