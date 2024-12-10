import CoreLocation
import XCTest

@testable import XyoClient

class LocationPayloadTests: XCTestCase {
    struct CoordinatesStruct: Encodable {
        let accuracy: CLLocationAccuracy
        let altitude: CLLocationDistance
        let altitudeAccuracy: CLLocationDistance
        let heading: CLLocationDirection
        let latitude: CLLocationDegrees
        let longitude: CLLocationDegrees
        let speed: CLLocationSpeed
    }

    struct CurrentLocationStruct: Encodable {
        let coords: CoordinatesStruct
        let timestamp: Date
    }

    func testLocationPayloadEncoding() throws {
        // Arrange: Create a CLLocation instance and the corresponding LocationPayload
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            altitude: 15.0,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 3.0,
            course: 90.0,
            speed: 2.5,
            timestamp: Date(timeIntervalSince1970: 1_609_459_200)  // Jan 1, 2021
        )
        let payload = LocationPayload(location)

        // Act: Encode the LocationPayload instance into JSON
        let jsonString = try PayloadBuilder.toJson(from: payload)

        // Assert: Verify the serialized JSON matches expectations
        let expectedJSON = """
            {
              "currentLocation" : {
                "coords" : {
                  "accuracy" : 5,
                  "altitude" : 15,
                  "altitudeAccuracy" : 15,
                  "heading" : 90,
                  "latitude" : 37.7749,
                  "longitude" : -122.4194,
                  "speed" : 2.5
                },
                "timestamp" : 1609459200000
              },
              "schema" : "network.xyo.location.current"
            }
            """.filter { !$0.isWhitespace }
        XCTAssertEqual(jsonString, expectedJSON)
        let dataHash = try PayloadBuilder.dataHash(from: payload)
        XCTAssertEqual(
            dataHash, Data("0c1f0c80481b0f391a677eab542a594a192081325b6416acc3dc99db23355ee2"))
        let hash = try PayloadBuilder.hash(fromWithMeta: EncodableWithMetaInstance(from: payload))
        XCTAssertEqual(
            hash, Data("0c1f0c80481b0f391a677eab542a594a192081325b6416acc3dc99db23355ee2"))
    }

    func testLocationPayloadEncodingHandlesNilValues() throws {
        // Arrange: Create a CLLocation instance with some properties unset
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            altitude: CLLocationDistance.nan,
            horizontalAccuracy: CLLocationAccuracy.nan,
            verticalAccuracy: CLLocationAccuracy.nan,
            course: CLLocationDirection.nan,
            speed: CLLocationSpeed.nan,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let payload = LocationPayload(location)

        // Act: Encode the LocationPayload instance into JSON
        let jsonString = try PayloadBuilder.toJson(from: payload)

        // Assert: Verify the serialized JSON handles NaN values gracefully (e.g., omitted or replaced)
        let expectedJSON = """
            {
              "currentLocation" : {
                "coords" : {
                  "latitude" : 0,
                  "longitude" : 0
                },
                "timestamp" : 0
              },
              "schema" : "network.xyo.location.current"
            }
            """.filter { !$0.isWhitespace }
        XCTAssertEqual(jsonString, expectedJSON)
        let dataHash = try PayloadBuilder.dataHash(from: payload)
        XCTAssertEqual(
            dataHash, Data("c1bd7396f998a50d20401efd4b5da0cf6670f9418c6f60b42f4c54f3663305c3"))
        let hash = try PayloadBuilder.hash(fromWithMeta: EncodableWithMetaInstance(from: payload))
        XCTAssertEqual(
            hash, Data("c1bd7396f998a50d20401efd4b5da0cf6670f9418c6f60b42f4c54f3663305c3"))
    }
}
