import CoreLocation

open class IosLocationPayload: EncodablePayloadInstance {

    public static let schema: String = "network.xyo.location.ios"

    var location: CLLocation

    public init(_ location: CLLocation) {
        self.location = location
        super.init(IosLocationPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case altitude
        case coordinate
        case course
        case courseAccuracy
        case ellipsoidalAltitude
        case floor
        case horizontalAccuracy
        case schema
        case sourceInformation
        case speed
        case speedAccuracy
        case timestamp
        case verticalAccuracy
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)

        try container.encodeIfValidNumeric(self.location.altitude, forKey: .altitude)
        try container.encode(
            IosLocationCoordinatePayloadStruct(self.location.coordinate), forKey: .coordinate)
        try container.encode(self.location.course, forKey: .course)
        if #available(iOS 13.4, *) {
            try container.encodeIfValidNumeric(
                self.location.courseAccuracy, forKey: .courseAccuracy)
        }
        if #available(iOS 15, *) {
            try container.encodeIfValidNumeric(
                self.location.ellipsoidalAltitude, forKey: .ellipsoidalAltitude)
        }
        if let floor = self.location.floor {
            try container.encode(
                IosLocationFloorPayloadStruct(floor), forKey: .floor)
        }
        try container.encodeIfValidNumeric(
            self.location.horizontalAccuracy, forKey: .horizontalAccuracy)
        if #available(iOS 15.0, *) {
            if let sourceInformation = self.location.sourceInformation {
                try container.encode(
                    IosLocationSourceInformationPayloadStruct(sourceInformation),
                    forKey: .sourceInformation)
            }
        }
        try container.encodeIfValidNumeric(self.location.speed, forKey: .speed)
        try container.encodeIfValidNumeric(self.location.speedAccuracy, forKey: .speedAccuracy)
        try container.encode(
            Int(self.location.timestamp.timeIntervalSince1970 * 1000), forKey: .timestamp)
        try container.encodeIfValidNumeric(
            self.location.verticalAccuracy, forKey: .verticalAccuracy)

    }
}
