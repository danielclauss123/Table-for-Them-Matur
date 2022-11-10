import Foundation
import SwiftUI
import Firebase

// MARK: - Class
@MainActor
class UpdatePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var newPasswordConfirmation = ""
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    var validInformation: Bool {
        !oldPassword.isEmpty && newPassword.isValidPassword && newPasswordConfirmation == newPassword
    }
}

// MARK: - Update
extension UpdatePasswordViewModel {
    func update() async {
        errorMessage = nil
        
        guard validInformation else {
            errorMessage = "Die eingegebenen Informationen sind nicht gültig."
            showingErrorAlert = true
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "Du must dich erneut anmelden. Melde dich ab, melde dich mit deinem alten Passwort erneut an und versuche dann nochmals."
            showingErrorAlert = true
            return
        }
        
        guard let email = user.email else {
            errorMessage = "Du bist nicht mit deiner Email angemeldet. Benutze zuerst die Email Anmeldung, bevor du dein Passwort ändern kannst."
            showingErrorAlert = true
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        do {
            try await user.reauthenticate(with: credential)
            try await user.updatePassword(to: newPassword)
        } catch {
            print("Failed to update password: \(error.localizedDescription)")
            
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
                case .wrongPassword:
                    errorMessage = "Das eingegebene alte Passwort ist nicht korrekt."
                case .userDisabled:
                    errorMessage = "Dein Account ist deaktiviert. Kontaktiere den App Developer um ihn zu reaktivieren."
                case .userMismatch:
                    errorMessage = "Du bist mit einem anderen Account angemeldet als mit der Email hier."
                case .requiresRecentLogin:
                    errorMessage = "Um dein Passwort zu ändern, melde dich erst einmal erneut an."
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
extension UpdatePasswordViewModel {
    var newPasswordColor: Color {
        newPassword.isEmpty ? .primary : (newPassword.isValidPassword ? .green : .red)
    }
    
    var newPasswordConfirmationColor: Color {
        newPasswordConfirmation.isEmpty ? .primary : (newPasswordConfirmation == newPassword && newPassword.isValidPassword ? .green : .red)
    }
}
