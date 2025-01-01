import SwiftUI

struct CommentEdit: View {
    @EnvironmentObject var commentService: LetterBooksdComment

    @Binding var comments: [Comment]
    @Binding var writing: Bool
    
    @State var commentBody = ""
    
    var comment: Comment
    
    func editComment() async {
        Task {
            do {
                let commentId = try await commentService.updateComment(comment: comment, body: commentBody)
                writing = false
                if let index = comments.firstIndex(where: { $0.id == commentId }) {
                    comments[index] = Comment(reviewId: comment.reviewId, id: commentId, user: comment.user, date: comment.date, body: comment.body)
                    }
            } catch {
                print("Comment edited successfully.")
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
                .navigationTitle("Edit Comment")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                await editComment()
                            }
                        }
                        .disabled(commentBody.isEmpty)
                    }
                }
            }
        }
}
