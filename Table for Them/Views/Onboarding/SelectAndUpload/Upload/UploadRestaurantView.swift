import SwiftUI

struct UploadRestaurantView: View {
    @Binding var presented: Bool
    
    @ObservedObject var viewModel: UploadRestaurantViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()
            
            Group {
                switch viewModel.uploadingState {
                    case .failed(let message):
                        VStack {
                            Text("\(Image(systemName: "exclamationmark.triangle")) \(message)")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            Button {
                                Task {
                                    await viewModel.uploadRestaurant()
                                }
                            } label: {
                                Label("Nochmal Versuchen", systemImage: "arrow.clockwise")
                                    .font(.headline)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.horizontal)
                    case .restaurantIsAlreadyTaken:
                        VStack {
                            Text("Jemand hat dieses Restaurant schon genommen. Wenn es deines ist, melde dich bei uns um dies abzuklären.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                presented = false
                            } label: {
                                Label("Zurück", systemImage: "arrow.left")
                                    .font(.headline)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.horizontal)
                    default:
                        ProgressView()
                }
            }
        }
        .background {
            NavigationLink(isActive: $viewModel.uploadWasSuccessful) {
                SuccessfulUploadView()
            } label: {
                Color.clear
            }
            .disabled(true)
        }
        .task {
            await viewModel.uploadRestaurant()
        }
    }
}


// MARK: - Previews
struct UploadRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UploadRestaurantView(presented: .constant(true), viewModel: UploadRestaurantViewModel(yelpRestaurant: YelpRestaurantOverview.fullExample))
        }
    }
}
