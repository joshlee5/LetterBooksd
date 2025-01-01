import SwiftUI

struct BookCollectionMetadata: View {
    var collection: BookCollection
    
    var body: some View {
            HStack() {
                Text(collection.name)
                    .font(.headline)
                    .bold()

                Spacer()
                
                Text(collection.user)
                    .font(.caption)
            }
            .background(.blue)
    }
}

//struct ColletionMetadata_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewMetadata(review: Review(
//            id: "12345",
//            title: "Preview",
//            user: "Anonymous",
//            date: Date(),
//            rating: "5",
//            body: "Lorem ipsum dolor sit something something amet"
//        ))
//    }
//}

//#Preview {
//    BookCollectionMetadata()
//}
