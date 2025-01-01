import SwiftUI

struct ReviewEntry: View {
    @EnvironmentObject var reviewService: LetterBooksdReview
    @EnvironmentObject var auth: LetterBooksdAuth

    @Binding var reviews: [Review]
    @Binding var writing: Bool
    
    @State var title = ""
    // Change later to reflect actual user id or username
    @State var user: String
    @State var rating = ""
    @State var reviewBody = ""
    

    func submitReview() async {
        // We take a two-part approach here: this first part sends the article to
        // the database. The `createArticle` function gives us its ID.
        Task {
            do {
                let reviewId = try await reviewService.createReview(review: Review(
                    id: UUID().uuidString, // Temporary, only here because Article requires it.
                    title: title,
                    user: user,
                    date: Date(),
                    rating: rating,
                    body: reviewBody
                ))
                
                reviews.append(Review(
                    id: reviewId,
                    title: title,
                    user: user,
                    date: Date(),
                    rating: rating,
                    body: reviewBody
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
                    Section(header: Text("Title")) {
                        TextField("", text: $title)
                    }
                    
                    Section(header: Text("Rating")) {
                        TextField("", text: $rating)
                    }
                    
                    Section(header: Text("Body")) {
                        TextEditor(text: $reviewBody)
                            .frame(minHeight: 256, maxHeight: .infinity)
                    }
                }
                .navigationTitle("Add Your Review!")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    // Review cannot be submitted for some reason
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Submit") {
                            Task {
                                await submitReview()
                            }
                        }
                        .disabled(title.isEmpty || rating.isEmpty || reviewBody.isEmpty)
                    }
                }
            }
        }

}

//#Preview {
//    ReviewEntry()
//}
