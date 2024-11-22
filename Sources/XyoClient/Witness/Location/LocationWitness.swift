import CoreLocation
import Foundation

open class LocationWitness: WitnessModuleAsync {

    private var locationService = LocationService()

    override open func observe(completion: @escaping ([Payload]?, Error?) -> Void) {
        locationService.requestAuthorization()
        locationService.requestLocation { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let location):
                    let iosLocationPayload = IosLocationPayload(location)
                    let locationPayload = LocationPayload(location)
                    completion([iosLocationPayload, locationPayload], nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
