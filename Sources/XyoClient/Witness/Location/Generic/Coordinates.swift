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

        // Helper function to check and encode non-NaN Double values
        func encodeIfValid(_ value: Double?, forKey key: CodingKeys) throws {
            if let value = value, !value.isNaN {
                try container.encode(value, forKey: key)
            }
        }

        try encodeIfValid(self.accuracy, forKey: .accuracy)
        try encodeIfValid(self.altitude, forKey: .altitude)
        try encodeIfValid(self.altitudeAccuracy, forKey: .altitudeAccuracy)
        try encodeIfValid(self.heading, forKey: .heading)
        try container.encode(self.latitude, forKey: .latitude) // Always encode latitude
        try container.encode(self.longitude, forKey: .longitude) // Always encode longitude
        try encodeIfValid(self.speed, forKey: .speed)
    }
}
