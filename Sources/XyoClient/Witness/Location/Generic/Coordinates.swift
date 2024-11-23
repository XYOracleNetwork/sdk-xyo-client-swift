import CoreLocation
import Foundation

struct CoordinatesStruct: Encodable {

    var accuracy: Double?
    var altitude: Double?
    var altitudeAccuracy: Double?
    var heading: Double?
    var latitude: Double
    var longitude: Double
    var speed: Double?

    init(
        accuracy: Double?,
        altitude: Double?,
        altitudeAccuracy: Double?,
        heading: Double?,
        latitude: Double,
        longitude: Double,
        speed: Double?
    ) {
        self.accuracy = accuracy
        self.altitude = altitude
        self.altitudeAccuracy = altitudeAccuracy
        self.heading = heading
        self.latitude = latitude
        self.longitude = longitude
        self.speed = speed
    }

    enum CodingKeys: String, CodingKey {
        case accuracy
        case altitude
        case altitudeAccuracy
        case heading
        case latitude
        case longitude
        case speed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let accuracy = self.accuracy {
            try container.encode(accuracy, forKey: .accuracy)
        }
        if let altitude = self.altitude {
            try container.encode(altitude, forKey: .altitude)
        }
        if let altitudeAccuracy = self.altitudeAccuracy {
            try container.encode(altitudeAccuracy, forKey: .altitudeAccuracy)
        }
        if let heading = self.heading {
            try container.encode(heading, forKey: .heading)
        }
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        if let speed = self.speed {
            try container.encode(speed, forKey: .speed)
        }
    }
}
