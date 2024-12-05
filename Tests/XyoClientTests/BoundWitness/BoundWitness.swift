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
        let payloadDataHash = try PayloadBuilder.dataHash(from: testPayload1)
        XCTAssertEqual(payloadDataHash, testPayload1Hash)
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        XCTAssertEqual(testVectorPrivateKey, address.privateKey!.toHex())
        XCTAssertEqual(testVectorAddress, address.address!.toHex())
        let bw = try BoundWitnessBuilder().signer(address).payload(
            "network.xyo.test", TestPayload1("network.xyo.test"))
        let (bwJson, _) = try bw.build()
        let hash = try PayloadBuilder.hash(fromWithMeta: bwJson)
        let dataHash = try PayloadBuilder.dataHash(from: bwJson.typedPayload)
        XCTAssertEqual(
            dataHash.toHex(), "6f731b3956114fd0d18820dbbe1116f9e36dc8d803b0bb049302f7109037468f")
        XCTAssertEqual(
            hash.toHex(), "c267291c8169e428aaedbbf52792f9378ee03910401ef882b653a75f85370722")
    }

    func testPayload_hash_returnsExpectedHash2() throws {
        let hash = try PayloadBuilder.dataHash(from: testPayload2)
        XCTAssertEqual(hash.toHex(), testPayload2Hash.toHex())
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        let bwJsonHash = try PayloadBuilder.dataHash(from: bwJson.typedPayload)
        let e = try? bwJson.toJson()
        if e != nil {
            print("\n")
            print(e!)
            print("\n")
        }
        XCTAssertEqual(
            bwJsonHash.toHex(), "6f731b3956114fd0d18820dbbe1116f9e36dc8d803b0bb049302f7109037468f")
    }

    func testPayload_hash_returnsExpectedHashWhenNested() throws {
        let hash = try PayloadBuilder.dataHash(from: testPayload2)
        XCTAssertEqual(hash, testPayload2Hash)
        let address = Account.fromPrivateKey(testVectorPrivateKey.hexToData()!)
        let bw = try BoundWitnessBuilder().signer(address).payload("network.xyo.test", testPayload2)
        let (bwJson, _) = try bw.build()
        let bwJsonHash = try PayloadBuilder.dataHash(from: bwJson.typedPayload)
        XCTAssertEqual(
            bwJsonHash.toHex(), "6f731b3956114fd0d18820dbbe1116f9e36dc8d803b0bb049302f7109037468f")
    }

    func testSequence_hash_returnsExpectedHash() throws {
        for testCase in boundWitnessSequenceTestCases {
            // Create accounts
            let signers = testCase.addresses.map { Account.fromPrivateKey($0) }
            // Ensure correct initial account state
            for (i, previousHash) in testCase.previousHashes.enumerated() {
                XCTAssertEqual(testCase.previousHashes[i], previousHash)
            }

            // Build the BW
            let bw = try BoundWitnessBuilder().signers(signers).payloads(testCase.payloads)
            let (bwJson, _) = try bw.build()
            let hash = try PayloadBuilder.dataHash(from: bwJson.typedPayload)

            // Ensure the BW is correct
            XCTAssertEqual(hash.toHex(), testCase.dataHash)

            // Ensure correct ending account state
            for signer in signers {
                XCTAssertEqual(signer.previousHash, hash)
            }
        }
    }
}
