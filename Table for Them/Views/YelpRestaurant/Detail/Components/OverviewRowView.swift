import SwiftUI

extension YelpRestaurantDetailView {
    struct OverviewRowView: View {
        let restaurant: YelpRestaurantDetail
        let distance: Double?
        let onTap: (InformationType) -> Void
        
        // MARK: - Body
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let openingHours = restaurant.openingHours {
                        informationBlock(title: "Öffnungszeiten") {
                            onTap(.openingHours)
                        } content: {
                            Text(openingHours.isOpenNow ? "Geöffnet" : "Geschlossen")
                                .foregroundColor(openingHours.isOpenNow ? .green : .red)
                        }
                        
                        divider
                    }
                    
                    if let priceInt = restaurant.priceInt {
                        informationBlock(title: "Preis") {
                            onTap(.price)
                        } content: {
                            ShortPriceView(price: priceInt)
                        }
                        
                        divider
                    }
                    
                    if let rating = restaurant.rating {
                        informationBlock(title: "Bewertung") {
                            onTap(.rating)
                        } content: {
                            ShortRatingView(rating: rating)
                        }
                        
                        divider
                    }
                    
                    if let distance = distance {
                        informationBlock(title: "Entfernung") {
                            onTap(.distance)
                        } content: {
                            Text("\(distance, specifier: "%.1f") km")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        
        // MARK: - Divider
        var divider: some View {
            Divider()
                .padding(.vertical, 10)
        }
        
        // MARK: - Information Block
        func informationBlock<Content: View>(title: String, action: @escaping () -> Void,  @ViewBuilder content: () -> Content) -> some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                
                content()
                    .font(.headline)
            }
            .onTapGesture(perform: action)
        }
        
        // MARK: - Information Type
        enum InformationType: Hashable {
            case openingHours, price, rating, distance
        }
    }
}


// MARK: - Previews
struct OverviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            YelpRestaurantDetailView.OverviewRowView(restaurant: YelpRestaurantDetail.fullExample1, distance: 5.6) { _ in }
                .previewLayout(.fixed(width: 300, height: 50))
            
            YelpRestaurantDetailView.OverviewRowView(restaurant: YelpRestaurantDetail.lackingExample, distance: nil) { _ in }
                .previewLayout(.fixed(width: 300, height: 50))
        }
    }
}
