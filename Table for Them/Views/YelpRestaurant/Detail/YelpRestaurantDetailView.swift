import SwiftUI

struct YelpRestaurantDetailView: View {
    let restaurant: YelpRestaurantDetail
    
    @State private var distance: Double?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            content
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Content
    var content: some View {
        ScrollView {
            ScrollViewReader { proxy in
                PhotosView(photoURLs: restaurant.photos ?? [])
                
                OverviewRowView(restaurant: restaurant, distance: distance) { type in
                    withAnimation {
                        proxy.scrollTo(type)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    if let rating = restaurant.rating, let reviewCount = restaurant.reviewCount {
                        ReviewView(rating: rating, reviewCount: reviewCount, yelpURL: restaurant.yelpURL)
                            .id(OverviewRowView.InformationType.rating)
                    }
                    
                    if let openingHours = restaurant.openingHours {
                        InsetScrollViewSection(title: "Öffnungszeiten") {
                            OpeningHoursView(openingHours: openingHours)
                        }
                        .id(OverviewRowView.InformationType.openingHours)
                    }
                    
                    MapAndAddressView(restaurant: restaurant, distance: $distance)
                        .id(OverviewRowView.InformationType.distance)
                    
                    if let displayPhone = restaurant.displayPhone, let phone = restaurant.phone {
                        ContactView(phone: phone, displayPhone: displayPhone)
                    }
                    
                    CreditView(yelpURL: restaurant.yelpURL)
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}


// MARK: - Previews
struct YelpRestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                YelpRestaurantDetailView(restaurant: YelpRestaurantDetail.fullExample1)
            }
            .navigationViewStyle(.stack)
            
            NavigationView {
                YelpRestaurantDetailView(restaurant: YelpRestaurantDetail.lackingExample)
            }
            .navigationViewStyle(.stack)
        }
    }
}
