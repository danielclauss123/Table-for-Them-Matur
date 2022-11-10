import SwiftUI

/// Displays the opening hours of a single day.
struct DayHoursView: View {
    let dayHours: [DayHours]
    
    // MARK: - Body
    var body: some View {
        if dayHours.isEmpty {
            Text("Geschlossen")
        } else {
            VStack(alignment: .trailing) {
                ForEach(dayHours, id: \.self) { hour in
                    Text(hour.text)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}


// MARK: - Previews
struct DayHoursView_Previews: PreviewProvider {
    static var previews: some View {
        DayHoursView(dayHours: OpeningHours.example.open)
            .previewLayout(.sizeThatFits)
    }
}
