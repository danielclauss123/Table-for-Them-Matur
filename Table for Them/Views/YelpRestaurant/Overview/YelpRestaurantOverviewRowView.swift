import SwiftUI

struct YelpRestaurantOverviewRowView: View {
    let restaurant: YelpRestaurantOverview
    
    @ScaledMetric var imageWidth = 60.0
    
    var body: some View {
        NavigationLink(destination: SelectYourRestaurantView(restaurantOverview: restaurant)) {
            HStack {
                AsyncImage(url: URL(string: restaurant.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Image.defaultPlaceholder()
                        .font(.headline)
                        .aspectRatio(1, contentMode: .fit)
                }
                .frame(width: imageWidth, height: imageWidth)
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if let location = restaurant.location {
                        Text(location.shortAddress)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}


// MARK: - Previews
struct YelpRestaurantOverviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        YelpRestaurantOverviewRowView(restaurant: YelpRestaurantOverview.fullExample)
            .previewLayout(.sizeThatFits)
    }
}
