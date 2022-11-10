import SwiftUI

struct MyAccountView: View {
    @StateObject var viewModel: MyAccountViewModel
    
    @State private var showingUpdatePasswordSheet = false
    @State private var showingUpdateEmailSheet = false
    @State private var showingSignOutConfirmation = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("Mein Restaurant") {
                        if let yelpRestaurant = viewModel.yelpRestaurant {
                            YelpRestaurantDetailView(restaurant: yelpRestaurant)
                        }
                    }
                    .disabled(viewModel.yelpRestaurant == nil)
                } header: {
                    header
                }
                
                Section {
                    Button("Password ändern") {
                        showingUpdatePasswordSheet = true
                    }
                    .sheet(isPresented: $showingUpdatePasswordSheet) {
                        UpdatePasswordView()
                    }
                    
                    Button("Email ändern") {
                        showingUpdateEmailSheet = true
                    }
                    .sheet(isPresented: $showingUpdateEmailSheet, onDismiss: {
                        Task {
                            await viewModel.loadRestaurant()
                        }
                    }) {
                        UpdateEmailView()
                    }
                }
                
                Section {
                    Button("Abmelden") {
                        showingSignOutConfirmation = true
                    }
                    .confirmationDialog("Möchtest du dich wirklich abmelden?", isPresented: $showingSignOutConfirmation) {
                        Button("Abmelden") {
                            viewModel.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Mein Account")
            .navigationBarTitleDisplayMode(.inline)
            .listTopErrorMessage(viewModel.errorMessage)
            .task {
                await viewModel.loadRestaurant()
            }
            .refreshable {
                await viewModel.loadRestaurant()
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.yelpRestaurant?.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } placeholder: {
                Image.defaultPlaceholder(Color(uiColor: .quaternarySystemFill))
                    .font(.headline)
            }
            .frame(width: 100, height: 100)
            .cornerRadius(50)
            
            Text(viewModel.restaurant?.name ?? "")
                .font(.title2)
                .textCase(.none)
                .foregroundColor(.primary)
            
            Text(viewModel.userEmail)
                .font(.subheadline)
                .textCase(.none)
                .foregroundColor(.secondary)
                .disabled(true)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    // MARK: - Initializer
    init() {
        self._viewModel = StateObject(wrappedValue: MyAccountViewModel())
    }
}


// MARK: - Previews
struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
