import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class BoundWitnessTests: XCTestCase {
    static var allTests = [
        ("testPayload_hash_returnsExpectedHash1", testPayload_hash_returnsExpectedHash1),
        ("testPayload_hash_returnsExpectedHash2", testPayload_hash_returnsExpectedHash2),
    ]

    override func setUp() {
        super.setUp()
        // Ensure previousHash = nil for tests addresses
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func testPayload_hash_returnsExpectedHash1() throws {
        let hash = try BoundWitnessBuilder.hash(testPayload1)
        XCTAssertEqual(hash, testPayload1Hash)
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload(
            "network.xyo.test", TestPayload1("network.xyo.test"))
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(
            bwJson._hash, "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }

    func testPayload_hash_returnsExpectedHash2() throws {
        let hash = try BoundWitnessBuilder.hash(testPayload2)
        XCTAssertEqual(hash, testPayload2Hash)
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(
            bwJson._hash, "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }

    func testPayload_hash_returnsExpectedHashWhenNested() throws {
        let hash = try BoundWitnessBuilder.hash(testPayload2)
        XCTAssertEqual(hash, testPayload2Hash)
        let address = Account.fromPrivateKey(key: testVectorPrivateKey.hexToData())
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        XCTAssertEqual(
            bwJson._hash, "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }
}
