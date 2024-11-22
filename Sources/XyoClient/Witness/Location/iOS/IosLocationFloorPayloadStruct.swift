import CoreLocation
import Foundation

struct IosLocationFloorPayloadStruct: Encodable {

    var floor: CLFloor

    init(_ floor: CLFloor) {
        self.floor = floor
    }

    enum CodingKeys: String, CodingKey {
        case level
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.floor.level, forKey: .level)
    }
}
