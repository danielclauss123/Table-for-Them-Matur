import SwiftUI

struct SearchYourRestaurantView: View {
    @StateObject var viewModel: SearchYourRestaurantViewModel
    @StateObject var locationSearcher: LocationSearcher
    
    @State private var showingLocationSheet = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchField("Restaurant Name", systemImage: "magnifyingglass", text: $viewModel.searchText)
                
                HStack {
                    LocationSearchButton(locationSearcher: locationSearcher)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Spacer()
            
            if locationSearcher.coordinate == nil {
                Text("Standort Unbekannt")
                    .foregroundColor(.secondary)
            } else if viewModel.restaurants.isEmpty {
                Text("Keine Ergebnisse")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(viewModel.restaurants) { restaurant in
                        YelpRestaurantOverviewRowView(restaurant: restaurant)
                    }
                }
            }
            
            Spacer()
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("Suche dein Restaurant")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Initializer
    init() {
        let viewModel = SearchYourRestaurantViewModel()
        
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._locationSearcher = StateObject(wrappedValue: viewModel.locationSearcher)
    }
}


// MARK: - Previews
struct SearchYourRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchYourRestaurantView()
        }
        .navigationViewStyle(.stack)
    }
}
