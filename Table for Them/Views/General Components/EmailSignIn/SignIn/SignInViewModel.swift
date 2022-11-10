import Foundation
import SwiftUI
import Firebase

// MARK: - Class
@MainActor
class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    var validInformation: Bool {
        !email.isEmpty && !password.isEmpty
    }
}

// MARK: - Sign In
extension SignInViewModel {
    func signIn() async {
        errorMessage = nil
        
        guard validInformation else {
            errorMessage = "Die eingegebenen Informationen sind nicht gültig."
            showingErrorAlert = true
            return
        }
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            print("Failed to sign in user: \(error.localizedDescription)")
            
            await MainActor.run {
                guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
                    errorMessage = "Es gab ein internes Problem."
                    showingErrorAlert = true
                    return
                }
                
                switch errorCode {
                case .networkError:
                    errorMessage = "Keine Internetverbindung. Überprüfe deine Verbindung und versuche es erneut."
                case .userNotFound:
                    errorMessage = "Es gibt keinen Account mit dieser Email. Geh zu Sign Up um einen zu erstellen."
                case .invalidEmail:
                    errorMessage = "Die Email Adresse ist ungültig. Überprüfe sie und versuche es erneut."
                case .userDisabled:
                    errorMessage = "Dein Account ist deaktiviert. Kontaktiere den App Developer um ihn zu reaktivieren."
                case .wrongPassword:
                    errorMessage = "Das eingegebene Passwort ist nicht korrekt."
                default:
                    errorMessage = "Es gab ein unbekanntes Problem. Versuche es erneut."
                }
                
                showingErrorAlert = true
            }
        }
    }
}
