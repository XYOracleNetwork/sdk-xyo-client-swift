import CoreLocation
import Foundation

open class LocationWitness: WitnessModuleAsync {
    private var _locationService: LocationServiceProtocol?

    private var locationService: LocationServiceProtocol {
        if let service = _locationService {
            return service
        } else {
            let initialized = LocationService()
            self._locationService = initialized
            return initialized
        }
    }

    override public init(account: AccountInstance? = nil) {
        super.init(account: account)
    }

    public convenience init(locationService: LocationServiceProtocol) {
        self.init(account: nil)
        self._locationService = locationService
    }

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
