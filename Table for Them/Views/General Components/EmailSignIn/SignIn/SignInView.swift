import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Binding var showingSignIn: Bool
    
    @StateObject var viewModel: SignInViewModel
    
    @State private var showingForgotPasswordView = false
    
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    var body: some View {
        VStack {
            emailSignIn
            
            Spacer()
            
            signInButton
            
            Button("Du hast noch keinen Account? - Sign Up") {
                showingSignIn.toggle()
            }
            .font(.headline)
            .sheet(isPresented: $showingForgotPasswordView) {
                ForgotPasswordView()
            }
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("Willkommen zurück")
    }
    
    // MARK: - Email Sign In
    var emailSignIn: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing, spacing: 15) {
                HStack {
                    Image(systemName: "envelope.circle.fill")
                        .font(.title2.bold())
                    
                    TextField("Email Adresse", text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "lock.circle.fill")
                        .font(.title2.bold())
                    
                    SecureField("Passwort", text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                        .textContentType(.password)
                        .submitLabel(.done)
                }
                
                Button("Passwort vergessen?") {
                    showingForgotPasswordView = true
                }
                .font(.caption)
            }
            .onSubmit {
                switch focusedField {
                    case .email:
                        focusedField = .password
                    case .password:
                        Task {
                            await viewModel.signIn()
                        }
                    default:
                        break
                }
            }
        }
    }
    
    // MARK: - Sign In Button
    var signInButton: some View {
        Button {
            Task {
                await viewModel.signIn()
            }
        } label: {
            Text("Sign In")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.validInformation)
        .alert("Sign In fehlgeschlagen", isPresented: $viewModel.showingErrorAlert) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage ?? "Es gab ein unbekanntes Problem.")
        }
    }
    
    // MARK: - Initializer
    init(showingSignIn: Binding<Bool>) {
        self._showingSignIn = showingSignIn
        self._viewModel = StateObject(wrappedValue: SignInViewModel())
    }
    
    // MARK: - Field
    enum Field {
        case email, password
    }
}


// MARK: - Previews
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView(showingSignIn: .constant(true))
        }
    }
}
