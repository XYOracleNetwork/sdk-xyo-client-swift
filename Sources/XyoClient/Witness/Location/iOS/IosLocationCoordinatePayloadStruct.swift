import CoreLocation
import Foundation

struct IosLocationCoordinatePayloadStruct: Encodable {

    var coordinate: CLLocationCoordinate2D

    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.coordinate.latitude, forKey: .latitude)
        try container.encode(self.coordinate.longitude, forKey: .longitude)
    }
}
