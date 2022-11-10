import SwiftUI

struct SignUpView: View {
    @Binding var showingSignIn: Bool
    
    @StateObject var viewModel: SignUpViewModel
    
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    var body: some View {
        VStack {
            emailSignUp
            
            Spacer()
            
            signUpButton
            
            Button("Du hast schon einen Account? - Sign In") {
                showingSignIn.toggle()
            }
            .font(.headline)
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("Willkommen")
    }

    // MARK: - Email Sign Up
    var emailSignUp: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "envelope.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.emailColor)
                    
                    TextField("Email Adresse", text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "lock.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.passwordColor)
                    
                    SecureField("Passwort", text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                        .textContentType(.newPassword)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "lock.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.passwordConfirmationColor)
                    
                    SecureField("Passwort Wiederholung", text: $viewModel.passwordConfirmation)
                        .focused($focusedField, equals: .passwordConfirmation)
                        .textContentType(.newPassword)
                        .submitLabel(.done)
                }
                
                Text("Das Passwort braucht mindestens 8 Zeichen mit einem gross und klein geschriebenen Buchstaben und einer Zahl.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .onSubmit {
                switch focusedField {
                    case .email:
                        focusedField = .password
                    case .password:
                        focusedField = .passwordConfirmation
                    case .passwordConfirmation:
                        Task {
                            await viewModel.signUp()
                        }
                    default:
                        break
                }
            }
        }
    }
    
    // MARK: - Sign Up Button
    var signUpButton: some View {
        Button {
            Task {
                await viewModel.signUp()
            }
        } label: {
            Text("Sign Up")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.validInformation)
        .alert("Sign Up fehlgeschlagen", isPresented: $viewModel.showingErrorAlert) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage ?? "Es gab ein unbekanntes Problem.")
        }
    }
    
    // MARK: - Initializer
    init(showingSignIn: Binding<Bool>) {
        self._showingSignIn = showingSignIn
        self._viewModel = StateObject(wrappedValue: SignUpViewModel())
    }
    
    // MARK: - Field
    enum Field {
        case email, password, passwordConfirmation
    }
}


// MARK: - Previews
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(showingSignIn: .constant(false))
        }
    }
}
