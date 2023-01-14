import SwiftUI

struct SignInUpHomeView: View {
    @State private var showingSignIn = false
    
    var body: some View {
        NavigationView {
            Group {
                if showingSignIn {
                    SignInView(showingSignIn: $showingSignIn)
                } else {
                    SignUpView(showingSignIn: $showingSignIn)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}


// MARK: - Previews
struct SignInUpHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SignInUpHomeView()
    }
}
