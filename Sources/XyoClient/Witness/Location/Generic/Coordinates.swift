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

        try container.encode(self.accuracy, forKey: .accuracy)
        try container.encode(self.altitude, forKey: .altitude)
        try container.encode(self.altitudeAccuracy, forKey: .altitudeAccuracy)
        try container.encode(self.heading, forKey: .heading)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.speed, forKey: .speed)
    }
}
