import SwiftUI

struct CommentEntry: View {
    @EnvironmentObject var commentService: LetterBooksdComment

    @Binding var comments: [Comment]
    @Binding var writing: Bool
    
    @State var reviewId: String
    // Change later to reflect actual user id or username
    @State var user: String
    @State var commentBody = ""
    

    func submitComment() async {
        // We take a two-part approach here: this first part sends the article to
        // the database. The `createArticle` function gives us its ID.
        Task {
            do {
                let commentId = try await commentService.createComment(comment: Comment(
                    reviewId: reviewId,
                    id: UUID().uuidString,
                    user: user,
                    date: Date(),
                    body: commentBody
                ))
                
                // As an optimization, instead of reloading all of the entries again, we
                // just _add a new Article in memory_. This makes things appear faster and
                // if the database creation worked fine, upon the next load we would then
                // get the real stored Article.
                //
                // There is some risk here—in the event of an error we might mistakenly
                // provide the wrong impression that the Article was stored when it actually
                // wasn’t. More sophisticated code can look at the published `error` variable
                // in the article service and provide some feedback if that error becomes
                // non-nil.
                comments.append(Comment(
                    reviewId: reviewId,
                    id: commentId,
                    user: user,
                    date: Date(),
                    body: commentBody
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
                    Section(header: Text("Comment")) {
                        TextEditor(text: $commentBody)
                            .frame(minHeight: 256, maxHeight: .infinity)
                    }
                }
                .navigationTitle("Share your comment!")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Submit") {
                            Task {
                                await submitComment()
                            }
                        }
                        .disabled(commentBody.isEmpty)
                    }
                }
            }
        }

}

//#Preview {
//    CommentEntry()
//}
