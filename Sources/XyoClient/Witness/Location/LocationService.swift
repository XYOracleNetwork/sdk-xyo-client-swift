import CoreLocation
import Foundation

public class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocation, Error>) -> Void)?

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // Method to request location authorization
    public func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Method to request the current location once
    public func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
    }

    // CLLocationManagerDelegate methods
    public func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            locationCompletion?(.success(location))
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
    }
}
