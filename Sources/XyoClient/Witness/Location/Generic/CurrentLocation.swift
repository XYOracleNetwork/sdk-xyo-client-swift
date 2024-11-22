import CoreLocation
import Foundation

struct CurrentLocationStruct: Encodable {

    var coords: CoordinatesStruct
    var timestamp: Date

    init(
        coords: CoordinatesStruct,
        timestamp: Date
    ) {
        self.coords = coords
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case coords
        case timestamp
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.coords, forKey: .coords)
        try container.encode(Int(self.timestamp.timeIntervalSince1970 * 1000), forKey: .timestamp)
    }
}
