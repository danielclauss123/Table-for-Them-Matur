import Foundation
import SwiftUI
import Firebase

// MARK: - Class
@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    var validInformation: Bool {
        !email.isEmpty
    }
}

// MARK: - Send Email
extension ForgotPasswordViewModel {
    func sendEmail() async {
        errorMessage = nil
        
        guard validInformation else {
            errorMessage = "Die eingegebenen Informationen sind nicht gültig."
            showingErrorAlert = true
            return
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("Sending forgot password email failed: \(error.localizedDescription)")
            
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
                    errorMessage = "Es gibt keinen Account mit dieser Email. Geh zu Sign Up und erstelle einen."
                case .invalidEmail:
                    errorMessage = "Die Email Adresse ist ungültig. Überprüfe sie und versuche es erneut."
                case .userDisabled:
                    errorMessage = "Dein Account ist deaktiviert. Kontaktiere den App Developer um ihn zu reaktivieren."
                default:
                    errorMessage = "Es gab ein unbekanntes Problem. Versuche es erneut."
                }
                
                showingErrorAlert = true
            }
        }
    }
}
