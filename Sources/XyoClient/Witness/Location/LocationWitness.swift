import CoreLocation
import Foundation

open class LocationWitness: WitnessModuleAsync {
    private let locationService = LocationService()
    
    override open func observe(completion: @escaping ([Payload]?, Error?) -> Void) {
        locationService.requestAuthorization()
        locationService.requestLocation { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let location):
                    let payload = LocationPayload(location)
                    completion([payload], nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
