import CoreLocation
import Foundation

protocol LocationServiceProtocol {
    func requestAuthorization()
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}
