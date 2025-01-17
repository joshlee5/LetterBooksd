/**
 * LetterBooksdAuth is an object that interacts with Firebase Authentication, allowing
 * it to keep track of user activities relating to login. It publishes its `user` variable
 * so that SwiftUI views will update when this variable changes.
 */
import Foundation

import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI

class LetterBooksdAuth: NSObject, ObservableObject, FUIAuthDelegate {
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    
    @Published var user: User?
    
    enum AuthError: Error {
        case userNotSignedIn
    }
    
    
    /**
     * You might not have overriden a constructor in Swift before...well, here it is.
     */
    override init() {
        super.init()
        
        // Multiple providers can be supported! See: https://firebase.google.com/docs/auth/ios/firebaseui
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(authUI: authUI!)
        ]

        
        // Note that authUI is marked as _optional_. If things don’t appear to work
        // as expected, check to see that you actually _got_ an authUI object from
        // the Firebase library.
        authUI?.delegate = self
        authUI?.providers = providers
    }

    /**
     * In another case of the documentation being somewhat behind the latest libraries,
     * this delegate method:
     *
     *     func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?)
     *
     * …has been deprecated in favor of the one below.
     */
    // Returning users being treated as new sign ups with Email Authentication: FirebaseUI Problem?
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let actualResult = authDataResult {
            user = actualResult.user
        }
    }

    func signOut() throws {
        try authUI?.signOut()

        // If we get past the logout attempt, we can safely clear the user.
        user = nil
    }
    
    func getUID() throws -> String {
        guard let userID = Auth.auth().currentUser?.uid else {
                throw AuthError.userNotSignedIn
            }
        return userID
    }
}
