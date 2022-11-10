import SwiftUI

struct OpeningHoursView: View {
    let openingHours: OpeningHours
    
    @State private var showingAllOpeningHours = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            header
                .background {
                    // This is needed to make the gesture work everywhere
                    Color(uiColor: .systemBackground)
                }
                .onTapGesture {
                    withAnimation {
                        showingAllOpeningHours.toggle()
                    }
                }
            
            if showingAllOpeningHours {
                allOpeningHours
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(openingHours.isOpenNow ? "Geöffnet" : "Geschlossen")
                    .foregroundColor(openingHours.isOpenNow ? .green : .red)
                if openingHours.isOpenNow {
                    DayHoursView(dayHours: openingHours.todaysHours)
                }
            }
            .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.\(showingAllOpeningHours ? "up" : "down")")
                .imageScale(.small)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - All Opening Hours
    var allOpeningHours: some View {
        VStack(alignment: .leading) {
            ForEach(Weekday.allCases.filter { $0 != .unknown }) { weekday in
                HStack(alignment: .top) {
                    Text(weekday.name)
                    
                    Spacer()
                    
                    DayHoursView(dayHours: openingHours.hours(forWeekday: weekday))
                        .font(.headline)
                }
                .padding(.top, 5)
            }
        }
    }
}


// MARK: - Previews
struct OpeningHoursView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningHoursView(openingHours: OpeningHours.example)
            .previewLayout(.sizeThatFits)
    }
}
