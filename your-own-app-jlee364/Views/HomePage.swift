import SwiftUI

struct HomePage: View {
    @EnvironmentObject var auth: LetterBooksdAuth
    @State var requestLogin = false
    @State private var error: Error?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                // Checks if User is signed in or not, if yes, they have access to three buttons
                if auth.user != nil {
                    VStack {
                        NavigationLink (destination: BookSearchView()) {
                            Text("Find Books to Read!")
                                .padding()
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .background(Color.gray)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                        
                        NavigationLink (destination: ReviewList(reviews: [], comments: [], user: self.getUser())) {
                            Text("Find Reviews from Our Users!")
                                .padding()
                                .foregroundColor(.green)
                                .background(Color.white)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                        
                        NavigationLink (destination: BookCollectionList(collections: [], user: self.getUser())) {
                            Text("View Users' Unique Book Collections!")
                                .padding()
                                .foregroundColor(.red)
                                .background(Color.black)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                        
                    }
                }
                else {
                    VStack {
                        Text("Welcome to LetterBooksd!")
                            .font(.largeTitle)
                            .padding()
                        
                        // Kinda a logo? Didn't turn out how I thought it would
                        ShapeSymbol()

                        Button("Sign In") {
                            requestLogin = true
                        }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                        
                    }
                    .sheet(isPresented: $requestLogin) {
                        if let authUI = auth.authUI {
                            AuthenticationViewController(authUI: authUI)
                        }
                    }
                }
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
}

//#Preview {
//    HomePage()
//}
