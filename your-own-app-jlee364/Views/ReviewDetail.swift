/**
 * ReviewDetail displays a single review model object.
 */
import SwiftUI

struct ReviewDetail: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var reviewService: LetterBooksdReview
    @Binding var reviews: [Review]
    @Binding var comments: [Comment] // fetch comments from firebase
    @State var user: String
    @State private var isEditing = false
    @State private var isBodyVisible = false
    @State private var error: Error?
    
    var review: Review
        
    func deleteReview (current_review: Review) async {
        let reviewId = current_review.id
        
        Task {
            do {
                if let index = reviews.firstIndex(where: { $0.id == reviewId }) {
                                reviews.remove(at: index)
                    }
                
                try await reviewService.removeReview(reviewID: reviewId)
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
        VStack {
            Text(review.title)
                .bold()
                .font(.headline)
                .padding()
            
            Text(review.user)
                .font(.subheadline)
                .padding()
            
            Text(review.date, style: .date)
                .font(.subheadline)
                .padding()
            
            Spacer()
            
            Text(review.rating)
                .bold()
                .underline()
            
            Spacer()

            Text(review.body).padding()
                .border(Color(.black))
                .opacity(isBodyVisible ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isBodyVisible = true
                    }
                }
                .padding()
            
            // Find way to hide these buttons is user id does not match with review.user and do same for comments and book collections
            if (self.getUser() == review.user)
            {
                HStack () {
                    Button("Delete") {
                        Task {
                            await deleteReview(current_review: review)
                        }
                    }
                    .padding()
                    .background(Color(.red))
                    .border(Color(.black))
                    Divider()
                    NavigationLink(destination: ReviewEdit(reviews: $reviews, writing: $isEditing, review: review), isActive: $isEditing) {
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
        .background(.yellow)
            
        Spacer()
        
        // Comments go here // comments keep resetting each time I go back to review, doesnt do it for when i stay so problem should not be with fetching and it appears in firebase
        NavigationLink(destination: CommentList(comments: comments, reviewId: review.id, user: user)) {
            Text("View Comments")
                .padding()
                .background(Color.red)
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
}

//struct ReviewDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewDetail(reviews: $reviews, review: Review(
//            id: "12345",
//            title: "Preview",
//            user: "Anonymous",
//            date: Date(),
//            body: "Lorem ipsum dolor sit something something amet"
//        ))
//    }
//}
