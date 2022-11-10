/*
 Abstract:
    Passwort und Email Check.
    Unwrap von String? mit UUID.
 */

import Foundation

// MARK: - Password
extension String {
    /// Validates whether the string contains 8 or more digits, a number, a lower- and an uppercased letter.
    var isValidPassword: Bool {
        // 8 or more digits, 1 capital, 1 lowercase, 1 number
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    /// Validates whether the string is a valid email.
    var isValidEmail: Bool {
        // something @ something . 2 - 64 letters
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-;:&/()]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: self)
    }
}

// MARK: - Optional
extension Optional where Wrapped == String {
    /// Unwraps the string with a UUID String.
    func unwrapWithUUID() -> String {
        self ?? UUID().uuidString
    }
}
