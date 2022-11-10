import SwiftUI

struct SelectYourRestaurantView: View {
    @StateObject var viewModel: UploadRestaurantViewModel
    
    @State private var detail: YelpRestaurantDetail?
    
    @State private var showingConfirmationCard = false
    @State private var showingUploadView = false
    
    // MARK: - Body
    var body: some View {
        Group {
            if let detail = detail {
                YelpRestaurantDetailView(restaurant: detail)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Color(uiColor: .secondarySystemBackground)
                            .ignoresSafeArea()
                    )
                    .navigationTitle(viewModel.yelpRestaurant.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .safeAreaBottomInset {
            Button {
                showingConfirmationCard = true
            } label: {
                Text("Mein Restaurant  \(Image(systemName: "checkmark"))")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .task {
            self.detail = try? await URLSession.shared.restaurantDetails(forYelpId: viewModel.yelpRestaurant.id)
        }
        .overlay {
            if showingConfirmationCard {
                HoldConfirmationCard(title: "Bist du wirklich der Besitzer dieses Restaurants?", message: "Es ist verboten ein Restaurant auszuwählen, welches nicht dir gehört.", isPresented: $showingConfirmationCard) {
                    showingUploadView = true
                    showingConfirmationCard = false
                }
            }
        }
        .overlay {
            if showingUploadView {
                UploadRestaurantView(presented: $showingUploadView, viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Initializer
    init(restaurantOverview: YelpRestaurantOverview) {
        self._viewModel = StateObject(wrappedValue: UploadRestaurantViewModel(yelpRestaurant: restaurantOverview))
    }
}


// MARK: - Previews
struct SelectYourRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectYourRestaurantView(restaurantOverview: .fullExample)
        }
    }
}
