/*
 Abstract:
    Gibt current user zurück oder wirft Error.
    Gibt optionalen current user zurück.
 */

import Foundation
import FirebaseAuth

extension Auth {
    /// Returns the current user or throws if it is nil.
    static func currentUser() throws -> User {
        guard let currentUser = auth().currentUser else {
            throw NSError(domain: AuthErrorDomain, code: AuthErrorCode.nullUser.rawValue)
        }
        
        return currentUser
    }
    
    /// The current user, nil if it is not available.
    static func currentUser() -> User? {
        auth().currentUser
    }
}
