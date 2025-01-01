/**
 * CommentDetail displays a single review model object.
 */
import SwiftUI

struct CommentDetail: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @EnvironmentObject var commentService: LetterBooksdComment
    @Binding var comments: [Comment]
    @State private var isEditing = false
    @State private var isBodyVisible = false
    @State private var error: Error?
    
    var comment: Comment
    
    func deleteComment (current_comment: Comment) async {
        let commentId = current_comment.id
        
        Task {
            do {
                if let index = comments.firstIndex(where: { $0.id == commentId }) {
                                comments.remove(at: index)
                    }
                
                try await commentService.removeComment(commentID: commentId)
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
            Text(comment.user)
            
            Text(comment.date, style: .date)

            Text(comment.body).padding()
                .border(Color(.black))
                .opacity(isBodyVisible ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isBodyVisible = true
                    }
                }
            if (self.getUser() == comment.user)
            {
                HStack () {
                    Button("Delete") {
                        Task {
                            await deleteComment(current_comment: comment)
                        }
                    }
                    .padding()
                    .background(Color(.red))
                    .border(Color(.black))
                    Divider()
                    NavigationLink(destination: CommentEdit(comments: $comments, writing: $isEditing, comment: comment), isActive: $isEditing) {
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
        .background(.red)
    }
}


//#Preview {
//    CommentDetail()
//}
