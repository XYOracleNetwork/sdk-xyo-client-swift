import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class BoundWitnessBuilderTests: XCTestCase {
    static var allTests = [
        ("Build Returns Expected Hash", test_build_returnsExpectedHash)
    ]

    override func setUp() {
        super.setUp()
        // Ensure previousHash = nil for tests addresses
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_build_returnsExpectedHash() throws {
        for testCase in boundWitnessSequenceTestCases {
            // Create accounts
            var signers: [AccountInstance] = []
            for (i, mnemonic) in testCase.mnemonics.enumerated() {
                let path = testCase.paths[i]
                if let account = try? Wallet.fromMnemonic(mnemonic: mnemonic, path: path) {
                    signers.append(account)
                } else {
                    XCTAssertTrue(false, "Error creating account from mnemonic")
                }
            }
            XCTAssertEqual(
                testCase.addresses.count,
                signers.count,
                "Incorrect number of accounts created."
            )
            XCTAssertEqual(
                testCase.addresses.compactMap { $0.lowercased() },
                signers.compactMap { $0.address?.toHex().lowercased() },
                "Incorrect addresses when creating accounts."
            )
            // Ensure correct initial account state
            for (i, previousHash) in testCase.previousHashes.enumerated() {
                XCTAssertEqual(
                    testCase.previousHashes[i],
                    previousHash,
                    "Incorrect previous hash for account"
                )
            }

            // Build the BW
            let bw = try BoundWitnessBuilder().signers(signers).payloads(testCase.payloads)
            let (bwJson, _) = try bw.build()
            let hash = try PayloadBuilder.dataHash(from: bwJson.typedPayload)

            // Ensure the BW is correct
            XCTAssertEqual(hash.toHex(), testCase.dataHash, "Incorrect data hash in BW")
            for (i, expectedPayloadHash) in testCase.payloadHashes.enumerated() {
                let actualPayloadHash = bwJson.typedPayload.payload_hashes[i]
                // Ensure payload hash is correct
                XCTAssertEqual(expectedPayloadHash, actualPayloadHash, "Incorrect payload hash in BW")
            }
            for (i, payload) in testCase.payloads.enumerated() {
                let actualSchema = bwJson.typedPayload.payload_schemas[i]
                // Ensure payload hash is correct
                XCTAssertEqual(payload.schema, actualSchema, "Incorrect payload schema in BW")
            }

            // Ensure correct ending account state
            for signer in signers {
                // Ensure previous hash is correct
                XCTAssertEqual(signer.previousHash, hash, "Incorrect previous hash for account")
            }
        }
    }
}
