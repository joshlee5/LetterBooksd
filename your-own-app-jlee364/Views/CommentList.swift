import SwiftUI

struct CommentList: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var commentService: LetterBooksdComment
    
    @State var comments: [Comment]
    @State var reviewId: String
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
                } else if comments.count == 0 {
                    VStack {
                        Spacer()
                        Text("No comments yet!.")
                        Spacer()
                    }
                } else {
                    List(comments) { comment in
                        if comment.reviewId == reviewId {
                            VStack {
                                CommentDetail(comments: $comments, comment: comment)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Comments")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("Add Your Comment!") {
                            writing = true
                        }
                        .background(Color(.green))
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $writing) {
                CommentEntry(comments: $comments, writing: $writing, reviewId: reviewId, user: user)
            }
            .task {
                fetching = true
                
                do {
                    comments = try await commentService.fetchComments()
                    fetching = false
                } catch {
                    self.error = error
                    fetching = false
                }
            }
        }
    }
}
    
struct CommentList_Previews: PreviewProvider {
    @State static var requestLogin = false
        
    static var previews: some View {
        CommentList(comments: [], reviewId: "12345", user: "Anonymous")
            .environmentObject(LetterBooksdAuth())
            
        CommentList(comments: [
            Comment(
                reviewId: "01234",
                id: "56789",
                user: "Anonymous",
                date: Date(),
                body: "Lorem ipsum dolor sit something something amet"
            ),
                
            Comment(
                reviewId: "13579",
                id: "24680",
                user: "Anonymous",
                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
                body: "Duis diam ipsum, efficitur sit amet something somesit amet"
            )
        ], reviewId: "67890", user: "Anonymous")
        .environmentObject(LetterBooksdAuth())
        .environmentObject(LetterBooksdComment())
    }
}
