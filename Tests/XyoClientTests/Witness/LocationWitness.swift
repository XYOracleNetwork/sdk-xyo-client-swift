import CoreLocation
import XCTest

@testable import XyoClient

private class MockLocationService: LocationServiceProtocol {
    var didRequestAuthorization = false
    var simulatedResult: Result<CLLocation, Error>?

    func requestAuthorization() {
        didRequestAuthorization = true
    }

    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if let result = simulatedResult {
            completion(result)
        }
    }
}

@available(iOS 13.0, *)
final class LocationWitnessTests: XCTestCase {
    static var allTests = [
        (
            "observe:returnsMultipleLocationPayloads",
            testLocationWitness_observe_returnsMultipleLocationPayloads
        )
    ]

    @available(iOS 15, *)
    func testLocationWitness_observe_returnsMultipleLocationPayloads() async throws {
        let locationServiceMock = MockLocationService()
        locationServiceMock.simulatedResult = .success(CLLocation(latitude: 1, longitude: 2))
        let sut = LocationWitness(locationService: locationServiceMock)
        let results = try await sut.observe()
        XCTAssertEqual(results.count, 2)
        let locationPayload = try XCTUnwrap(
            results.compactMap { $0 as? LocationPayload }.first, "Missing location payload.")
        XCTAssertEqual(locationPayload.schema, "network.xyo.location")
        let iosLocationPayload = try XCTUnwrap(
            results.compactMap { $0 as? IosLocationPayload }.first, "Missing iOS location payload.")
        XCTAssertEqual(iosLocationPayload.schema, "network.xyo.location.ios")

    }
}
