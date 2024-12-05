import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class BoundWitnessBuilderTests: XCTestCase {
    static var allTests = [
        ("Build Returns Expected Hash", test_build_returnsExpectedHash),
    ]

    override func setUp() {
        super.setUp()
        // Ensure previousHash = nil for tests addresses
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_build_returnsExpectedHash() throws {
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
