import Foundation

extension Reservation {
    static let example = Reservation(
        id: "87F617A1-3886-4847-9697-62A9D92FE1F4",
        customerId: "Y7hPaT9KUaMQKnBxW8nHMjYzMaE2",
        customerName: "Daniel Clauss",
        numberOfPeople: 4,
        restaurantId: "mMp8DiGAeAXc70bhh1Po7rImuIt1",
        yelpId: "RTj_xQwaz8Dy3BbeVxYiQg",
        roomId: "6770978C-0D0C-457C-A44B-E7EA6B181F86",
        tableId: "B79E7E68-5C7E-4268-A9D7-231D2BF24F91",
        date: Date.now.addingTimeInterval(60 * 60 * 24 * 7)
    )
    
    static let examples = [
        example,
        Reservation(
            id: "A1846F73-3AE2-46C2-A89E-46C4CFF8DD3D",
            customerId: "Y7hPaT9KUaMQKnBxW8nHMjYzMaE2",
            customerName: "Daniel Clauss",
            numberOfPeople: 5,
            restaurantId: "mMp8DiGAeAXc70bhh1Po7rImuIt1",
            yelpId: "RTj_xQwaz8Dy3BbeVxYiQg",
            roomId: "6770978C-0D0C-457C-A44B-E7EA6B181F86",
            tableId: "7562D18A-FDA1-4C57-928D-5D57F666F30E",
            date: Date.now.addingTimeInterval(60 * 60 * 24 * 5)
        )
    ]
}
