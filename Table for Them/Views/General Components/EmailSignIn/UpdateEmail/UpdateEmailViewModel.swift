import Foundation
import SwiftUI
import Firebase

// MARK: - Class
@MainActor
class UpdateEmailViewModel: ObservableObject {
    @Published var password = ""
    @Published var newEmail = ""
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    var validInformation: Bool {
        !password.isEmpty && newEmail.isValidEmail
    }
}

// MARK: - Update
extension UpdateEmailViewModel {
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
        
        guard let oldEmail = user.email else {
            errorMessage = "Du bist nicht mit deiner Email angemeldet. Benutze zuerst die Email Anmeldung, bevor du dein Passwort ändern kannst."
            showingErrorAlert = true
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            try await user.updateEmail(to: newEmail)
        } catch {
            print("Updating the email failed: \(error.localizedDescription)")
            
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
                    errorMessage = "Die neue Email Adresse ist ungültig. Überprüfe sie und versuche es erneut."
                case .wrongPassword:
                    errorMessage = "Das eingegebene Passwort ist nicht korrekt."
                case .userDisabled:
                    errorMessage = "Dein Account ist deaktiviert. Kontaktiere den App Developer um ihn zu reaktivieren."
                case .userMismatch:
                    errorMessage = "Du bist mit einem anderen Account angemeldet als mit der Email hier."
                case .requiresRecentLogin:
                    errorMessage = "Um dein Passwort zu ändern, melde dich erst einmal erneut an."
                case .emailAlreadyInUse:
                    errorMessage = "Es gibt bereits einen Account mit dieser Email. Solltest du ihn besitzen, lösche ihn und versuche dann erneut."
                default:
                    errorMessage = "Es gab ein unbekanntes Problem. Versuche es erneut."
                }
                
                showingErrorAlert = true
            }
        }
    }
}

// MARK: - UI Properties
extension UpdateEmailViewModel {
    var newEmailColor: Color {
        newEmail.isEmpty ? .primary : (newEmail.isValidEmail ? .green : .red)
    }
}
