import SwiftUI

struct ReviewList: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var reviewService: LetterBooksdReview

    @State var reviews: [Review]
    @State var comments: [Comment]
    @State var user: String
    @State var error: Error?
    @State var fetching = false
    @State var writing = false
    @State var searchText = ""

    var body: some View {
        ZStack() {
            LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
                                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if fetching {
                    ProgressView()
                } else if error != nil {
                    Text("Something went wrong…we wish we can say more 🤷🏽")
                } else if reviews.count == 0 {
                    VStack {
                        Spacer()
                        Text("There are no reviews.")
                        Spacer()
                    }
                } else {
                    List(reviews) { review in
                        NavigationLink {
                            ReviewDetail(reviews: $reviews, comments: $comments, user: user, review: review)
                        } label: {
                            ReviewMetadata(review: review)
                        }
                    }
                }
            }
            .navigationTitle("LetterBooksd: Find Books and Reviews")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("Add Your Review!") {
                            writing = true
                        }
                        .background(Color(.green))
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $writing) {
            ReviewEntry(reviews: $reviews, writing: $writing, user: user)
        }
        .task (id: searchText) {
            fetching = true

            do {
                reviews = try await searchText == "" ? reviewService.fetchReviews() : reviewService.searchReviews(query: searchText)
                fetching = false
            } catch {
                self.error = error
                fetching = false
            }
        }.searchable(text: $searchText)
        .onAppear(perform: {
            print("Live \(searchText)")
        })
        .onSubmit {
            print("Submit \(searchText)")
        }
    }
}

struct ReviewList_Previews: PreviewProvider {
    @State static var requestLogin = false

    static var previews: some View {
        ReviewList(reviews: [], comments: [], user: "Anonymous")
            .environmentObject(LetterBooksdAuth())

        ReviewList(reviews: [
            Review(
                id: "12345",
                title: "Preview",
                user: "Anonymous",
                date: Date(),
                rating: "5",
                body: "Lorem ipsum dolor sit something something amet"
            ),

            Review(
                id: "67890",
                title: "Some time ago",
                user: "Anonymous",
                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
                rating: "5",
                body: "Duis diam ipsum, efficitur sit amet something somesit amet"
            )
        ], comments:
                    [], user: "Anonymous")
        .environmentObject(LetterBooksdAuth())
        .environmentObject(LetterBooksdReview())
    }
}


