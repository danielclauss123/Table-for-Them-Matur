import SwiftUI
import CoreLocation

extension YelpRestaurantDetailView {
    struct MapAndAddressView: View {
        let restaurant: YelpRestaurantDetail
        @Binding var distance: CLLocationDistance?
        
        // MARK: - Body
        var body: some View {
            InsetScrollViewSection(title: "Karte") {
                VStack {
                    map
                    
                    Divider()
                    
                    address
                }
            }
        }
        
        // MARK: - Map
        var map: some View {
            RouteMapView(
                destination: restaurant.coordinate,
                destinationName: restaurant.name
            ) { mkRoute in
                distance = mkRoute.distance / 1000
            }
            .frame(height: 270)
            .cornerRadius(10)
        }
        
        // MARK: - Address
        var address: some View {
            Button {
                restaurant.coordinate.openInMaps(withName: restaurant.name)
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        if !(restaurant.location?.longAddress.isEmpty ?? true) {
                            Text("Addresse")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                    }
                    
                    if let location = restaurant.location {
                        Text(location.longAddress)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}


// MARK: - Previews
struct MapAndAddressView_Previews: PreviewProvider {
    static var previews: some View {
        YelpRestaurantDetailView.MapAndAddressView(restaurant: .fullExample1, distance: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
