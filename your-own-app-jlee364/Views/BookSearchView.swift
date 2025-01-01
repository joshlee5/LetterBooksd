import SwiftUI

struct BookSearchView: View {
    @State var query: String = ""
    @State var books: [Book] = []
    @State var loading = false
    @State private var error: Error?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("Enter Title of Book you want to find.", text: $query)
                    .padding()
                    .border(Color.gray)

                Button("Search") {
                    Task {
                        let bookPage = await searchBooks()
                        books = bookPage?.items ?? []
                    }
                }
                .padding()
                .disabled(query.isEmpty)
                
                if loading {
                    ProgressView()
                }
                
                ForEach((books ?? []), id: \.self) { book in
                    // One view per for each instance, wrap in stack to correct
                    NavigationLink {
                        BookDescriptionView(book: book)
                    } label: {
                        BookMetadata(book: book)
                    }
                }

            }
        }
    }
    
    func searchBooks() async -> BookPage? {
        loading = true
        print(query)
        do {
            let bookPage = try await getBookPage(query: query)
            loading = false
            return bookPage
        }
        catch {
            self.error = error
            print("Error: Could not search for book.")
        }
        return nil
    }
}

//#Preview {
//    BookSearchView()
//}
