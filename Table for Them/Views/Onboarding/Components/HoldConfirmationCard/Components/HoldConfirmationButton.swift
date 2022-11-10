import SwiftUI

/// A button that needs to be pressed for a visual amount of time before it activates.
struct HoldConfirmationButton: View {
    var systemImage: String = "checkmark"
    var duration: Double = 2.0
    var action: () -> Void
    
    @State private var percentage = 0.0
    
    var body: some View {
        ZStack {
            Circle().fill(Color.accentColor)
            
            Circle().strokeBorder(lineWidth: 10)
                .foregroundStyle(.regularMaterial)
            
            PercentageArc(percentageFilled: percentage)
                .strokeBorder(lineWidth: 10)
                .foregroundStyle(Color.accentColor)
            
            Image(systemName: systemImage)
                .font(.title.bold())
                .foregroundColor(.white)
        }
        .onLongPressGesture(minimumDuration: duration) {
            percentage = 100
            action()
        } onPressingChanged: { isPressed in
            if isPressed {
                withAnimation(.linear(duration: duration)) {
                    percentage = 100
                }
            } else {
                withAnimation(.default) {
                    percentage = 0
                }
            }
        }
    }
}


// MARK: - Previews
struct HoldConfirmationButton_Previews: PreviewProvider {
    static var previews: some View {
        HoldConfirmationButton { }
            .frame(width: 100, height: 100)
    }
}
