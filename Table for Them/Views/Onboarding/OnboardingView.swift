import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Finde dein Restaurant und erstelle den ersten Tischplan.")
                        .multilineTextAlignment(.center)
                }
            }
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .overlay(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .safeAreaBottomInset {
                NavigationLink(destination: SearchYourRestaurantView()) {
                    Text("Finde dein Restaurant  \(Image(systemName: "arrow.right"))")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .navigationTitle("Willkommen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Previews
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
