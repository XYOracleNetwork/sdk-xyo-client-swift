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
        let dataHash = try PayloadBuilder.dataHash(from: testPayload1)
        XCTAssertEqual(dataHash, testPayload1Hash)
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        let bw = try BoundWitnessBuilder().signer(address).payload(
            "network.xyo.test", TestPayload1("network.xyo.test"))
        let (bwJson, _) = try bw.build()
        let hash = try PayloadBuilder.hash(from: bwJson)
        let e = try? bwJson.toJson()
        if (e != nil) {
            print("\n")
            print(e!)
            print("\n")
        }
        XCTAssertEqual(
            hash.toHex(), "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }

    func testPayload_hash_returnsExpectedHash2() throws {
        let hash = try PayloadBuilder.hash(from: testPayload2)
        XCTAssertEqual(hash, testPayload2Hash)
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        let bwJsonHash = try PayloadBuilder.hash(from: bwJson)
        XCTAssertEqual(
            bwJsonHash.toHex(), "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }

    func testPayload_hash_returnsExpectedHashWhenNested() throws {
        let hash = try PayloadBuilder.hash(from: testPayload2)
        XCTAssertEqual(hash, testPayload2Hash)
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        let bwJsonHash = try PayloadBuilder.hash(from: bwJson)
        XCTAssertEqual(
            bwJsonHash.toHex(), "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35")
    }
}
