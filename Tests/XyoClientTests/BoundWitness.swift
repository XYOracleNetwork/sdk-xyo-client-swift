import XCTest
@testable import XyoClient

class TestPayload1SubObject: Encodable {
    var numberValue = 2
    var stringValue = "yo"
}

class TestPayload1: XyoPayload {
    var timestamp = 1618603439107
    var numberField = 1
    var objectField = TestPayload1SubObject()
    var stringField = "there"
}

class TestPayload2SubObject: Encodable {
    var stringValue = "yo"
    var numberValue = 2
}

class TestPayload2: XyoPayload {
    var stringField = "there"
    var objectField = TestPayload1SubObject()
    var timestamp = 1618603439107
    var numberField = 1
}

var knownHash = "7dcf152241b0dcc86c3cd052727f213ab0912af6a98dcd7843cbaab9170ab201"

@available(iOS 13.0, *)
final class BoundWitnessTests: XCTestCase {
    static var allTests = [
        ("testNotAuthenticated", testNotAuthenticated),
        ("testPayload1", testPayload1),
        ("testPayload2", testPayload2),
        ("testPayload1", testPayload1WithSend),
        ("testPayload2", testPayload2WithSend)
    ]
    
    func testNotAuthenticated() {
        let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
        let api = XyoArchivistApiClient.get(config)
        XCTAssertEqual(api.authenticated, false)
    }
    
    func testPayload1() throws {
        let address = try XyoAddress(phrase: "test")
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload1("network.xyo.test"))
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }
    
    func testPayload1WithSend() throws {
        let address = try XyoAddress(phrase: "test")
        let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
        let api = XyoArchivistApiClient.get(config)
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload1("network.xyo.test"))
        let apiExpectation = expectation(description: "API Call")
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
        try api.postBoundWitness(bwJson) { json, error in
            XCTAssertEqual(error == nil, true)
            XCTAssertEqual(json, 1)
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testPayload2() throws {
        let address = try XyoAddress(phrase: "test")
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload2("network.xyo.test"))
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }
    
    func testPayload2WithSend() throws {
        let address = try XyoAddress(phrase: "test")
        let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
        let api = XyoArchivistApiClient.get(config)
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload2("network.xyo.test"))
        let apiExpectation = expectation(description: "API Call")
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
        try api.postBoundWitness(bwJson) { json, error in
            XCTAssertEqual(error == nil, true)
            XCTAssertEqual(json == 1, true)
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
}
