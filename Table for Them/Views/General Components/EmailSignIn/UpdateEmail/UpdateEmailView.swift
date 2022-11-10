import SwiftUI

struct UpdateEmailView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: UpdateEmailViewModel
    
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                enterFields
                
                Spacer()
                
                updateEmailButton
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Email ändern")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Enter Fields
    var enterFields: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "lock.circle.fill")
                        .font(.title2.bold())
                    
                    SecureField("Passwort", text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                        .textContentType(.password)
                        .submitLabel(.next)
                }
                
                HStack {
                    Image(systemName: "envelope.circle")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.newEmailColor)
                    
                    TextField("Neue Email Adresse", text: $viewModel.newEmail)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .submitLabel(.done)
                }
            }
            .onSubmit {
                switch focusedField {
                    case .password:
                        focusedField = .email
                    case .email:
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
    
    // MARK: - Update Email Button
    var updateEmailButton: some View {
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
        .alert("Email Adresse ändern fehlgeschlagen", isPresented: $viewModel.showingErrorAlert) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage ?? "Es gab ein unbekanntes Problem.")
        }
    }
    
    // MARK: - Initializer
    init() {
        self._viewModel = StateObject(wrappedValue: UpdateEmailViewModel())
    }
    
    // MARK: - Field
    enum Field {
        case password, email
    }
}


// MARK: - Previews
struct UpdateEmailView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailView()
    }
}
