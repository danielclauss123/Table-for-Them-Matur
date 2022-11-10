import SwiftUI

struct SuccessfulUploadView: View {
    var body: some View {
        ScrollView {
            Text("Dein Account wurde erfolgreich erstellt!")
        }
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .overlay(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        .safeAreaBottomInset {
            Button {
                AccountManager.shared.checkRestaurantDocumentExistence()
            } label: {
                Text("Weiter  \(Image(systemName: "arrow.right"))")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .navigationTitle("Upload erfolgreich")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Previews
struct SuccessfulUploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SuccessfulUploadView()
        }
    }
}
