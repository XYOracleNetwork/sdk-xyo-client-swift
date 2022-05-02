import XCTest
@testable import XyoClient

class TestPayload1SubObject: Encodable {
    var number_value = 2
    var string_value = "yo"
}

class TestPayload1: XyoPayload {
    var timestamp = 1618603439107
    var number_field = 1
    var object_field = TestPayload1SubObject()
    var string_field = "there"
    
    enum CodingKeys: String, CodingKey {
        case schema
        case timestamp
        case number_field
        case object_field
        case string_field
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number_field, forKey: .number_field)
        try container.encode(object_field, forKey: .object_field)
        try container.encode(schema, forKey: .schema)
        try container.encode(string_field, forKey: .string_field)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

class TestPayload2SubObject: Encodable {
    var string_value = "yo"
    var number_value = 2
}

class TestPayload2: XyoPayload {
    var string_field = "there"
    var object_field = TestPayload1SubObject()
    var timestamp = 1618603439107
    var number_field = 1
    
    enum CodingKeys: String, CodingKey {
        case string_field
        case object_field
        case timestamp
        case number_field
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number_field, forKey: .number_field)
        try container.encode(object_field, forKey: .object_field)
        try container.encode(string_field, forKey: .string_field)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

var knownHash = "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35"

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
        let config = XyoArchivistApiConfig("temp", "https://beta.api.archivist.xyo.network")
        let api = XyoArchivistApiClient.get(config)
        XCTAssertEqual(api.authenticated, false)
    }
    
    func testPayload1() throws {
        let hash = try BoundWitnessBuilder.hash(TestPayload1("network.xyo.test"))
        XCTAssertEqual(hash, "13898b1fc7ef16c6eb8917b4bdd1aabbc1981069f035c51d4166a171273bfe3d")
        let address = XyoAddress(testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload1("network.xyo.test"))
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }
    
    func testPayload1WithSend() throws {
        let address = XyoAddress(testVectorPrivateKey.hexToData())
        let config = XyoArchivistApiConfig("temp", "https://beta.api.archivist.xyo.network")
        let api = XyoArchivistApiClient.get(config)
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload1("network.xyo.test"))
        let apiExpectation = expectation(description: "API Call")
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
        try api.postBoundWitness(bwJson) { error in
            XCTAssertTrue(error == nil, error!)
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testPayload2() throws {
        let address = XyoAddress(testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload2("network.xyo.test"))
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }
    
    func testPayload2WithSend() throws {
        let address = XyoAddress(testVectorPrivateKey.hexToData())
        let config = XyoArchivistApiConfig("temp", "http://localhost:8080")
        let api = XyoArchivistApiClient.get(config)
        let bw = try BoundWitnessBuilder().witness(address).payload("network.xyo.test", TestPayload2("network.xyo.test"))
        let apiExpectation = expectation(description: "API Call")
        let bwJson = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
        try api.postBoundWitness(bwJson) { error in
            XCTAssertEqual(error == nil, true)
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
}
