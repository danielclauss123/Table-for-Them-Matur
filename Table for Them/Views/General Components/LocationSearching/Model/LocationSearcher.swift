/*
 Abstract:
    A class that combines the CLLocationManager and MKLocalSearchCompletion to get the user location either by GPS or by a text entered address provided by the user.
 Info:
    The coordinate attribute is published and not a computed property. When using only this model, this doesn't make much sense and using a computed property would be safer and less complicated. However, this class is referenced by the RestaurantRepository and a published property for coordinate is needed, so that the repository can update when the coordinate changes (done with Combine).
 */

import Foundation
import Combine
import MapKit

/// A class that combines the CLLocationManager and MKLocalSearchCompletion to get the user location either by GPS or by a text entered address provided by the user.
///
/// Use the coordinate attribute to get the current coordinate.
class LocationSearcher: NSObject, ObservableObject {
    @Published var searchText = ""
    @Published private(set) var coordinate: CLLocationCoordinate2D?
    
    @Published var userLocationSelected = true {
        didSet {
            setCoordinate()
            
            if userLocationSelected {
                searchText = Self.userLocationText
            }
        }
    }
    @Published private(set) var searchedPlacemark: MKPlacemark? {
        didSet {
            setCoordinate()
        }
    }
    @Published private(set) var placemarkIsGettingSelected = false // It needs this, so that the change in search text, that comes from the selection, does not set the searched placemark to nil.
    
    @Published private var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
    @Published private var userLocation: CLLocation? {
        didSet {
            setCoordinate()
        }
    }
    @Published private var locationError: Error?
    
    private let locationManager = CLLocationManager()
    
    @Published private(set) var searchCompletions = [MKLocalSearchCompletion]()
    @Published private var searchError: Error?
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var queryCancellable: AnyCancellable?
    
    static let userLocationText = "Dein Standort"
    static let locationNotFoundText = "Ort nicht gefunden"
    
    /// A closure that gets called when the location source gets selected. This is perfect to set the center for a map, for example.
    var locationSourceSelected: (CLLocationCoordinate2D?) -> Void = { _ in }
    
    /// The display text for the selected location.
    var locationText: String {
        if coordinate != nil {
            return searchText
        } else {
            return "Unbekannt"
        }
    }
    
    /// Whether the user has allowed location use.
    var locationServiceAvailable: Bool {
        locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse
    }
    
    /// A possible error that occurred by the location service or the address search.
    var error: Error? {
        locationError ?? searchError
    }
    
    // MARK: - Initializer
    override init() {
        super.init()
        
        locationManager.delegate = self
        startLocationUpdates()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        
        queryCancellable = $searchText
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { text in
                if !self.placemarkIsGettingSelected {
                    self.searchedPlacemark = nil
                }
                
                if text != Self.userLocationText {
                    self.userLocationSelected = false
                }
                
                if text.isEmpty || text == Self.userLocationText || text == Self.locationNotFoundText {
                    self.searchCompletions = []
                } else {
                    self.searchCompleter.queryFragment = text
                }
                
                self.placemarkIsGettingSelected = false
            }
        
        Task {
            await selectUserLocation()
        }
    }
    
    /// The initializer for the example.
    private init(coordinate: CLLocationCoordinate2D) {
        self.searchText = "Example Coordinate"
        self.coordinate = coordinate
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    /// Sets the coordinate to the appropriate value. Call this function whenever one of the properties that decide the coordinate changes.
    private func setCoordinate() {
        coordinate = userLocationSelected ? userLocation?.coordinate : searchedPlacemark?.coordinate
    }
    
    // MARK: - Public Functions
    /// Selects the first one of the search completions for the entered text.
    @MainActor func selectFirstCompletion() async {
        guard let completion = searchCompletions.first else {
            return
        }
        
        await selectCompletion(completion)
        locationSourceSelected(coordinate)
    }
    
    /// Sets the given search completion as the one to provide the location.
    @MainActor func selectCompletion(_ searchCompletion: MKLocalSearchCompletion) async {
        placemarkIsGettingSelected = true
        searchText = "\(searchCompletion.title)\(searchCompletion.subtitle.isEmpty ? "" : ", \(searchCompletion.subtitle)")"
        searchedPlacemark = nil
        do {
            searchedPlacemark = try await searchCompletion.placemark()
            if searchedPlacemark == nil {
                searchText = Self.locationNotFoundText
            }
            locationSourceSelected(coordinate)
        } catch {
            searchError = error
        }
    }
    
    /// Selects the device location as the source for the coordinate.
    @MainActor func selectUserLocation() {
        guard locationServiceAvailable else { return }
        searchedPlacemark = nil
        userLocationSelected = true
        locationSourceSelected(coordinate)
    }
}

// MARK: - CLLocationManager Functions
extension LocationSearcher: CLLocationManagerDelegate {
    func startLocationUpdates() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationStatus = manager.authorizationStatus
        
        if locationAuthorizationStatus == .authorizedWhenInUse || locationAuthorizationStatus == .authorizedAlways {
            if searchedPlacemark == nil {
                userLocationSelected = true
            }
        } else {
            userLocationSelected = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
}

// MARK: - MKLocalSearchCompleter Functions
extension LocationSearcher: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompletions = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search service failed: \(error.localizedDescription)")
        searchError = error
    }
}

// MARK: - Example
extension LocationSearcher {
    static let example = LocationSearcher(coordinate: CLLocationCoordinate2D(latitude: 47.49230, longitude: 8.73363))
}
