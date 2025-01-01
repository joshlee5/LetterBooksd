import SwiftUI

struct BookMetadata: View {
    var book: Book
    
    var body: some View {
        HStack {
            Text(book.volumeInfo?.title ?? "N/A")
            ForEach(book.volumeInfo?.authors ?? ["N/A"], id: \.self) { author in
                Text(author)
            }
            Text(book.volumeInfo?.publishedDate ?? "N/A")
                
            // Might need to do preprocessing to turn link into URL
            AsyncImage(url: URL(string: book.volumeInfo?.imageLinks?.smallThumbnail ?? "N/A"))
        }
    }
}

//#Preview {
//    BookMetadata()
//}
