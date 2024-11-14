import XCTest

@testable import XyoClient

class TestPayload1SubObject: Encodable {
    var number_value = 2
    var string_value = "yo"
}

class TestPayload1: Payload {
    var timestamp = 1_618_603_439_107
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

class TestPayload2: Payload {
    var string_field = "there"
    var object_field = TestPayload1SubObject()
    var timestamp = 1_618_603_439_107
    var number_field = 1

    enum CodingKeys: String, CodingKey {
        case schema
        case string_field
        case object_field
        case timestamp
        case number_field
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

var knownHash = "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35"

@available(iOS 13.0, *)
final class BoundWitnessTests: XCTestCase {
    static var allTests = [
        ("testPayload1", testPayload1),
        ("testPayload2", testPayload2),
    ]

    func testPayload1() throws {
        let hash = try BoundWitnessBuilder.hash(TestPayload1("network.xyo.test"))
        XCTAssertEqual(hash, "c915c56dd93b5e0db509d1a63ca540cfb211e11f03039b05e19712267bb8b6db")
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload(
            "network.xyo.test", TestPayload1("network.xyo.test"))
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }

    func testPayload2() throws {
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let testPayload2 = TestPayload2("network.xyo.test")
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(bwJson._hash, knownHash)
    }
}
