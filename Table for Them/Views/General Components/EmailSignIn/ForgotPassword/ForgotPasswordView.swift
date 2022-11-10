import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ForgotPasswordViewModel
    
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                emailEnterField
                
                Spacer()
                
                sendNewPasswordButton
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Passwort vergessen")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Email Enter Field
    var emailEnterField: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "envelope.circle.fill")
                        .font(.title2.bold())
                    
                    TextField("Email Adresse", text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .submitLabel(.done)
                }
                
                Text("Du wirst ihn den nächsten Minuten eine Mail mit einem Link zur Änderung erhalten.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .onSubmit {
                Task {
                    await viewModel.sendEmail()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Send New Password Button
    var sendNewPasswordButton: some View {
        Button {
            Task {
                await viewModel.sendEmail()
                if viewModel.errorMessage == nil {
                    dismiss()
                }
            }
        } label: {
            Text("Send neues Passwort")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.validInformation)
        .alert("Neues Passwort senden fehlgeschlagen", isPresented: $viewModel.showingErrorAlert) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage ?? "Es gab ein unbekanntes Problem.")
        }
    }
    
    // MARK: - Initializer
    init() {
        self._viewModel = StateObject(wrappedValue: ForgotPasswordViewModel())
    }
    
    // MARK: - Field
    enum Field {
        case email
    }
}


// MARK: - Previews
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
