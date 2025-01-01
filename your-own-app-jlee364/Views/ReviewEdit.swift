import SwiftUI

struct ReviewEdit: View {
    @EnvironmentObject var reviewService: LetterBooksdReview

    @Binding var reviews: [Review]
    @Binding var writing: Bool
    
    @State var title = ""
    // Change later to reflect actual user id or username
    @State var user = ""
    @State var rating = ""
    @State var reviewBody = ""
    
    var review: Review
    
    func editReview() async {
        Task {
            do {
                let reviewId = try await reviewService.updateReview(review: review, title: title, rating: rating, body: reviewBody)
                writing = false
                if let index = reviews.firstIndex(where: { $0.id == reviewId }) {
                    reviews[index] = Review(id: reviewId, title: review.title, user: review.user, date: review.date, rating: review.rating, body: review.body)
                    }
            } catch {
                print("Review edited successfully.")
            }
        }
    }

    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("Title")) {
                        TextField("", text: $title)
                    }
                    
                    Section(header: Text("Body")) {
                        TextEditor(text: $reviewBody)
                            .frame(minHeight: 256, maxHeight: .infinity)
                    }
                }
                .navigationTitle("Edit Current Review")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                await editReview()
                            }
                        }
                        .disabled(title.isEmpty || reviewBody.isEmpty)
                    }
                }
            }
        }
}
