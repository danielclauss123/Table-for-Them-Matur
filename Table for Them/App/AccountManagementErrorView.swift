import SwiftUI

struct AccountManagementErrorView: View {
    @ObservedObject var accountManager: AccountManager
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("\(Image(systemName: "exclamationmark.triangle")) Es gab ein Problem mit der Server Verbindung: \(accountManager.errorMessage ?? "Unknown Error"). Überprüfe deine Internetverbindung und versuche erneut.")
                .foregroundColor(.secondary)
            
            Button {
                accountManager.checkRestaurantDocumentExistence()
            } label: {
                Label("Versuche erneut", systemImage: "arrow.clockwise")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
    }
}


// MARK: - Previews
struct AccountManagementErrorView_Previews: PreviewProvider {
    static var previews: some View {
        AccountManagementErrorView(accountManager: AccountManager.shared)
    }
}
