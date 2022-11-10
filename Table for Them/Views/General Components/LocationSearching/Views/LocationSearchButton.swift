import SwiftUI

struct LocationSearchButton: View {
    @ObservedObject var locationSearcher: LocationSearcher
    
    var onTap: () -> Void = { }
    
    @State private var showingLocationSearchSheet = false
    
    // MARK: - Body
    var body: some View {
        Button {
            showingLocationSearchSheet = true
            onTap()
        } label: {
            Label(locationSearcher.locationText, systemImage: "location")
                .symbolVariant(locationSearcher.coordinate == nil ? .slash : .none)
                .font(.subheadline.bold())
                .foregroundColor(locationSearcher.coordinate == nil ? .secondary : (locationSearcher.userLocationSelected ? .blue : .primary))
        }
        .lineLimit(1)
        .sheet(isPresented: $showingLocationSearchSheet) {
            LocationSearchSheet(viewModel: locationSearcher)
        }
    }
}


// MARK: - Previews
struct LocationSearchButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchButton(locationSearcher: LocationSearcher())
            .previewLayout(.sizeThatFits)
    }
}
