import CoreLocation

open class LocationPayload: EncodablePayloadInstance {

    public static let schema: String = "network.xyo.location.current"

    var location: CLLocation

    public init(_ location: CLLocation) {
        self.location = location
        super.init(LocationPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case currentLocation
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)

        let coords: CoordinatesStruct = CoordinatesStruct(
            accuracy: self.location.horizontalAccuracy,
            altitude: self.location.altitude,
            altitudeAccuracy: self.location.altitude,
            heading: self.location.course,
            latitude: self.location.coordinate.latitude,
            longitude: self.location.coordinate.longitude,
            speed: self.location.speed
        )
        let timestamp = self.location.timestamp
        let currentLocation: CurrentLocationStruct = CurrentLocationStruct(
            coords: coords, timestamp: timestamp)
        try container.encode(currentLocation, forKey: .currentLocation)
    }
}
