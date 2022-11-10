import Foundation
import SwiftUI
import FirebaseAuth

// MARK: - Class
@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var passwordConfirmation = ""
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    var validInformation: Bool {
        email.isValidEmail && password.isValidPassword && passwordConfirmation == password
    }
}

// MARK: - Sign In
extension SignUpViewModel {
    func signUp() async {
        errorMessage = nil
        
        guard validInformation else {
            errorMessage = "Die eingegebenen Informationen sind nicht gültig."
            showingErrorAlert = true
            return
        }
        
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            print("Failed to create new user: \(error.localizedDescription)")
            
            await MainActor.run {
                guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
                    errorMessage = "Es gab ein internes Problem."
                    showingErrorAlert = true
                    return
                }
                
                switch errorCode {
                case .networkError:
                    errorMessage = "Keine Internetverbindung. Überprüfe deine Verbindung und versuche es erneut."
                case .invalidEmail:
                    errorMessage = "Die Email Adresse ist ungültig. Überprüfe sie und versuche es erneut."
                case .emailAlreadyInUse:
                    errorMessage = "Es gibt bereits einen Account mit dieser Email. Geh zu Sign In."
                case .weakPassword:
                    errorMessage = "Dein Passwort ist nicht sicher genug. Les die Angaben und versuche es erneut."
                default:
                    errorMessage = "Es gab ein unbekanntes Problem. Versuche es erneut."
                }
                
                showingErrorAlert = true
            }
        }
    }
}

// MARK: - UI Properties
extension SignUpViewModel {
    var emailColor: Color {
        email.isEmpty ? .primary : (email.isValidEmail ? .green : .red)
    }
    
    var passwordColor: Color {
        password.isEmpty ? .primary : (password.isValidPassword ? .green : .red)
    }
    
    var passwordConfirmationColor: Color {
        passwordConfirmation.isEmpty ? .primary : (passwordConfirmation == password && password.isValidPassword ? .green : .red)
    }
}
