/*
 Abstract:
    Class für Location Anzeige in MapView.
 
 Note:
    Privacy - Location ... muss im Info.plist file sein.
 
 Source:
    Paul Hudson, https://www.hackingwithswift.com/100/swiftui/78
    Bearbeitet: On first update closure hinzugefügt
 */

import CoreLocation

/// A class that requests and fetches the user location.
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    var onFirstUpdate: (CLLocationCoordinate2D?) -> Void = { _ in }
    
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    var madeFirstUpdate = false

    override init() {
        super.init()
        manager.delegate = self
    }
    
    convenience init(onFirstUpdate: @escaping (CLLocationCoordinate2D?) -> Void) {
        self.init()
        self.onFirstUpdate = onFirstUpdate
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        if !madeFirstUpdate {
            onFirstUpdate(lastKnownLocation)
            madeFirstUpdate = true
        }
    }
}
