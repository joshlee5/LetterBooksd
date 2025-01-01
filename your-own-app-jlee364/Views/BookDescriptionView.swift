import SwiftUI

struct BookDescriptionView: View {
    
    var book: Book
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)

        ScrollView {
            VStack{
                AsyncImage(url: URL(string: book.volumeInfo?.imageLinks?.thumbnail ?? "N/A"))
                
                Text(book.volumeInfo?.title ?? "N/A")
                    .bold()
                
                HStack {
                    Text("Author: ")
                    ForEach(book.volumeInfo?.authors ?? ["N/A"], id: \.self) { author in
                        Text(author)
                    }
                }
                HStack {
                    Text("Publisher: ")
                    Text(book.volumeInfo?.publisher ?? "N/A")
                }
                HStack {
                    Text("Published: ")
                    Text(book.volumeInfo?.publishedDate ?? "N/A")
                }
                HStack {
                    Text("Number of Pages: ")
                    Text(String(book.volumeInfo?.pageCount ?? 0))
                }
                Text("Summary")
                    .underline()
                
                Text(book.volumeInfo?.description ?? "N/A")
                    .background(Rectangle().foregroundColor(.cyan))
            }
        }
    }
}

//#Preview {
//    BookDescriptionView()
//}
