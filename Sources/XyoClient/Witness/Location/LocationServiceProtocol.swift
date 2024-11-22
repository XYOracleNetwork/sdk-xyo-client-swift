import CoreLocation
import Foundation

public protocol LocationServiceProtocol {
    func requestAuthorization()
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}
