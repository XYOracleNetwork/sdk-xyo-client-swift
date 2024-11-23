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

        try container.encodeIfValidNumeric(self.accuracy, forKey: .accuracy)
        try container.encodeIfValidNumeric(self.altitude, forKey: .altitude)
        try container.encodeIfValidNumeric(self.altitudeAccuracy, forKey: .altitudeAccuracy)
        try container.encodeIfValidNumeric(self.heading, forKey: .heading)
        try container.encode(self.latitude, forKey: .latitude)  // Always encode latitude
        try container.encode(self.longitude, forKey: .longitude)  // Always encode longitude
        try container.encodeIfValidNumeric(self.speed, forKey: .speed)
    }
}
