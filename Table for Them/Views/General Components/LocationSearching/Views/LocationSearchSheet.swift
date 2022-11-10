import SwiftUI
import MapKit

struct LocationSearchSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: LocationSearcher
    
    @FocusState private var searchFieldIsFocused: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    searchField
                    
                    if let error = viewModel.error {
                        Text("Problem: \(error.localizedDescription)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                List {
                    yourLocationButton
                    
                    ForEach(viewModel.searchCompletions, id: \.self) { completion in
                        searchCompletionButton(completion)
                    }
                }
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .navigationTitle("Standort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        submitOrDone()
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Search Field
    var searchField: some View {
        SearchField(
            "Addresse, Postleitzahl, Stadt, ...",
            systemImage: "location.magnifyingglass", backgroundColor: Color(uiColor: .systemGray5),
            text: $viewModel.searchText
        ) { isEditing in
            if isEditing && viewModel.userLocationSelected {
                viewModel.searchText = ""
            }
        }
        .textContentType(.fullStreetAddress)
        .submitLabel(.done)
        .onSubmit {
            submitOrDone()
        }
        .focused($searchFieldIsFocused)
        .foregroundColor(viewModel.userLocationSelected ? .blue : .primary)
        .task {
            searchFieldIsFocused = true
        }
    }
    
    // MARK: - Your Location Button
    var yourLocationButton: some View {
        Button {
            viewModel.selectUserLocation()
            dismiss()
        } label: {
            HStack {
                Image(systemName: "location")
                    .symbolVariant(viewModel.locationServiceAvailable ? .fill : .slash)
                    .font(.title3)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text("Mein Standort")
                        .bold()
                }
            }
            .foregroundColor(viewModel.locationServiceAvailable ? .blue : .secondary)
        }
        .disabled(!viewModel.locationServiceAvailable)
    }
    
    // MARK: - Search Completion Button
    func searchCompletionButton(_ completion: MKLocalSearchCompletion) -> some View {
        Button {
            Task {
                await viewModel.selectCompletion(completion)
                dismiss()
            }
        } label: {
            HStack {
                Image(systemName: "location")
                    .font(.title3)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text(completion.title)
                        .bold()
                    if !completion.subtitle.isEmpty {
                        Text(completion.subtitle)
                    }
                }
            }
        }
        .foregroundColor(.primary)
    }
    
    // MARK: - Submit Or Done
    func submitOrDone() {
        if viewModel.searchText.isEmpty {
            viewModel.selectUserLocation()
            dismiss()
        } else {
            Task {
                await viewModel.selectFirstCompletion()
                dismiss()
            }
        }
    }
}


// MARK: - Previews
struct LocationSearchSheet_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchSheet(viewModel: LocationSearcher())
    }
}
