import SwiftUI

struct HoldConfirmationCard: View {
    let title: String
    let message: String
    
    @Binding var isPresented: Bool
    
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                VStack {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
                .padding(15)
                
                Divider()
                    .padding(.horizontal, -15)
                
                HoldConfirmationButton {
                    isPresented = false
                    action()
                }
                .frame(width: 120, height: 120)
                .padding(5)
                
                Divider()
                    .padding(.horizontal, -15)
                
                Button(role: .destructive) {
                    isPresented = false
                } label: {
                    Text("Abbrechen")
                        .font(.title3.bold())
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                }
            }
            .background(.regularMaterial)
            .cornerRadius(15)
            .frame(width: 300)
        }
    }
}


// MARK: - Previews
struct HoldConfirmationCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            HoldConfirmationCard(title: "Are you the owner of this restaurant?", message: "Claiming a restaurant that doesn't belong to you is not allowed.", isPresented: .constant(true)) { }
        }
    }
}
