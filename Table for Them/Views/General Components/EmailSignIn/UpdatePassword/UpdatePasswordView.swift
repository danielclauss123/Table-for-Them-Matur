import SwiftUI

struct UpdatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: UpdatePasswordViewModel
    
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                enterFields
                
                Spacer()
                
                updatePasswordButton
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Passwort ändern")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Enter Fields
    var enterFields: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "lock.circle.fill")
                        .font(.title2.bold())
                    
                    SecureField("Altes Passwort", text: $viewModel.oldPassword)
                        .focused($focusedField, equals: .oldPassword)
                        .textContentType(.password)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "lock.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.newPasswordColor)
                    
                    SecureField("Neues Passwort", text: $viewModel.newPassword)
                        .focused($focusedField, equals: .newPassword)
                        .textContentType(.newPassword)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "lock.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.newPasswordConfirmationColor)
                    
                    SecureField("Neues Password Wiederholung", text: $viewModel.newPasswordConfirmation)
                        .focused($focusedField, equals: .newPasswordConfirmation)
                        .textContentType(.newPassword)
                        .submitLabel(.done)
                }
                
                Text("Das Passwort braucht mindestens 8 Zeichen mit einem gross und klein geschriebenen Buchstaben und einer Zahl.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .onSubmit {
                switch focusedField {
                    case .oldPassword:
                        focusedField = .newPassword
                    case .newPassword:
                        focusedField = .newPasswordConfirmation
                    case .newPasswordConfirmation:
                        Task {
                            await viewModel.update()
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }
                    default:
                        break
                }
            }
        }
    }
    
    // MARK: - Update Password Button
    var updatePasswordButton: some View {
        Button {
            Task {
                await viewModel.update()
                if viewModel.errorMessage == nil {
                    dismiss()
                }
            }
        } label: {
            Text("Ändern")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.validInformation)
        .alert("Passwort ändern fehlgeschlagen", isPresented: $viewModel.showingErrorAlert) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage ?? "Es gab ein unbekanntes Problem.")
        }
    }
    
    // MARK: - Initializer
    init() {
        self._viewModel = StateObject(wrappedValue: UpdatePasswordViewModel())
    }
    
    // MARK: - Field
    enum Field {
        case oldPassword, newPassword, newPasswordConfirmation
    }
}


// MARK: - Previews
struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordView()
    }
}
