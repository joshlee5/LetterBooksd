/**
 * ReviewMetadata is a view that displays side information about its given review.
 */
import SwiftUI

struct ReviewMetadata: View {
    var review: Review
    
    var body: some View {
            HStack() {
                Text(review.title)
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                Text(review.rating)
                    .bold()
                    .underline()

                Spacer()
                
                Text(review.user)
                    .font(.caption)
                
                Spacer()

                VStack(alignment: .trailing) {
                    Text(review.date, style: .date)
                        .font(.caption)

                    Text(review.date, style: .time)
                        .font(.caption)
                }
            }
            .background(.yellow)
    }
}

struct ReviewMetadata_Previews: PreviewProvider {
    static var previews: some View {
        ReviewMetadata(review: Review(
            id: "12345",
            title: "Book is mid af",
            user: "Anonymous",
            date: Date(),
            rating: "5",
            body: "Lorem ipsum dolor sit something something amet"
        ))
    }
}
