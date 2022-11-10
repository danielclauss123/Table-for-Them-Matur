import Foundation

// MARK: - Opening Hours
extension OpeningHours {
    static let example = OpeningHours(isOpenNow: true, open: [
        DayHours(isOvernight: false, start: "1000", end: "2015", day: 0),
        DayHours(isOvernight: true, start: "2200", end: "0300", day: 1),
        DayHours(isOvernight: false, start: "j700", end: "2015", day: 2),
        DayHours(isOvernight: false, start: "1000", end: "2015", day: 3),
        DayHours(isOvernight: false, start: "0900", end: "1600", day: 3),
        DayHours(isOvernight: false, start: "1000", end: "2015", day: 5),
        DayHours(isOvernight: false, start: "1000", end: "2015", day: 6),
    ])
}

// MARK: - Location
extension YelpLocation {
    static let example = YelpLocation(
        address1: "Langgasse 58",
        city: "Winterthur",
        zipCode: "8400",
        state: "ZH",
        displayAddress: ["Langgasse 58", "Winterthur, ZH 8400"]
    )
}

// MARK: - Restaurant Overview
extension YelpRestaurantOverview {
    static let fullExample = YelpRestaurantOverview(
        id: "h2eeVnhUL8zEbTnUrjJomw",
        name: "Restaurant Hirschli",
        coordinates: Coordinate(latitude: 47.4742813, longitude: 8.3077803),
        isClosed: false,
        imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/3z8n_I2Jw9acNH9GVDWpDQ/o.jpg",
        location: YelpLocation.example
    )
    
    static let closedExample = YelpRestaurantOverview(
        id: "h2eeVnhUL8zEbTnUrjJomw",
        name: "Restaurant Hirschli",
        coordinates: Coordinate(latitude: 47.4742813, longitude: 8.3077803),
        isClosed: true,
        imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/3z8n_I2Jw9acNH9GVDWpDQ/o.jpg",
        location: YelpLocation.example
    )
    
    static let lackingExample = YelpRestaurantOverview(
        id: "h2eeVnhUL8zEbTnUrjJomw",
        name: "Restaurant Hirschli",
        coordinates: Coordinate(latitude: 47.4742813, longitude: 8.3077803),
        isClosed: nil,
        imageUrl: nil,
        location: nil
    )
}

// MARK: - Restaurant Detail
extension YelpRestaurantDetail {
    static let examples = [fullExample1, lackingExample, fullExample2]
    
    static let fullExample1 = YelpRestaurantDetail(
        id: "h2eeVnhUL8zEbTnUrjJomw",
        name: "Restaurant Hirschli",
        imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/3z8n_I2Jw9acNH9GVDWpDQ/o.jpg",
        isClosed: false,
        url: "https://www.yelp.com/biz/restaurant-hirschli-baden?adjust_creative=w214zEncs1_JRZSEaEfjng&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=w214zEncs1_JRZSEaEfjng",
        phone: "0522027422",
        displayPhone: "+41 52 202 74 22",
        reviewCount: 12,
        rating: 4.5,
        location: YelpLocation.example,
        coordinates: Coordinate(latitude: 47.4742813, longitude: 8.3077803),
        photos: ["https://s3-media2.fl.yelpcdn.com/bphoto/3z8n_I2Jw9acNH9GVDWpDQ/o.jpg", "https://s3-media4.fl.yelpcdn.com/bphoto/GKUXvdiR8FoYTsu5sPlUOg/o.jpg", "https://s3-media4.fl.yelpcdn.com/bphoto/4XPgGvNy8c6nOS_Cp6W06Q/o.jpg"],
        price: "$$",
        hours: [OpeningHours.example],
        specialHours: []
    )
    
    static let fullExample2 = YelpRestaurantDetail(
        id: UUID().uuidString,
        name: "Kafisatz",
        imageUrl: "https://s3-media0.fl.yelpcdn.com/bphoto/b65JHPl73YODrcKlGxvPRg/o.jpg",
        isClosed: false,
        url: "https://www.yelp.com/biz/gary-danko-san-francisco?adjust_creative=wpr6gw4FnptTrk1CeT8POg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=wpr6gw4FnptTrk1CeT8POg",
        phone: "0522027422",
        displayPhone: "076 283 11 21",
        reviewCount: 5,
        rating: 4.5,
        location: YelpLocation.example,
        coordinates: Coordinate(latitude: 45, longitude: 8),
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/b65JHPl73YODrcKlGxvPRg/o.jpg", "https://prinz.de/wp-content/uploads/2019/05/restaurant-massi.jpg", "https://www.mein-ruhrgebiet.blog/wp-content/uploads/2019/01/Fine_Dining_Spitzenkueche_Goldener_Anker_Dorsten_Restaurant_Kochschule_hochkant.jpg"],
        price: "$",
        hours: [OpeningHours.example],
        specialHours: nil
    )
    
    static let lackingExample = YelpRestaurantDetail(
        id: "V9jc1T-S1nuRCVq643-Fog",
        name: "Seerestaurant",
        imageUrl: nil,
        isClosed: false,
        url: "https://www.yelp.com/biz/seerestaurant-l%C3%BCtzelau-weggis?adjust_creative=w214zEncs1_JRZSEaEfjng&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=w214zEncs1_JRZSEaEfjng",
        phone: nil,
        displayPhone: nil,
        reviewCount: nil,
        rating: nil,
        location: nil,
        coordinates: Coordinate(latitude: 47.0243912, longitude: 8.4609299),
        photos: nil,
        price: nil,
        hours: nil,
        specialHours: nil
    )
}
