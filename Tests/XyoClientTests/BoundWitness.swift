import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class BoundWitnessTests: XCTestCase {
    static var allTests = [
        ("testPayload_hash_returnsExpectedHash1", testPayload_hash_returnsExpectedHash1),
        ("testPayload_hash_returnsExpectedHash2", testPayload_hash_returnsExpectedHash2),
    ]

    func testPayload_hash_returnsExpectedHash1() throws {
        let hash = try BoundWitnessBuilder.hash(testPayload1)
        XCTAssertEqual(hash, "c915c56dd93b5e0db509d1a63ca540cfb211e11f03039b05e19712267bb8b6db")
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload(
            "network.xyo.test", TestPayload1("network.xyo.test"))
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(bwJson._hash, testPayload1Hash)
    }

    func testPayload_hash_returnsExpectedHash2() throws {
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(bwJson._hash, testPayload2Hash)
    }
}
