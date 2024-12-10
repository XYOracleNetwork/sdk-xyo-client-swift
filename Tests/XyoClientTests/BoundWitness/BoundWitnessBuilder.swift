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
            let builder = try BoundWitnessBuilder().signers(signers).payloads(testCase.payloads)
            let (bw, payloads) = try builder.build()
            let dataHash = try PayloadBuilder.dataHash(from: bw.typedPayload)
            //            print(
            //                try PayloadBuilder.toJsonWithMeta(
            //                    from: bw.typedPayload, meta: bw.meta))
            let rootHash = try PayloadBuilder.hash(from: bw.typedPayload, meta: bw.typedMeta)

            // Ensure the BW is correct
            XCTAssertEqual(dataHash.toHex(), testCase.dataHash, "Incorrect data hash in BW")
            XCTAssertEqual(rootHash.toHex(), testCase.rootHash, "Incorrect root hash in BW")
            for (i, expectedPayloadHash) in testCase.payloadHashes.enumerated() {
                let actualPayloadHash = bw.typedPayload.payload_hashes[i]
                // Ensure payload hash is correct from test data
                XCTAssertEqual(
                    expectedPayloadHash, actualPayloadHash,
                    "Incorrect payload hash in BW as compared to test data")
                // Ensure payload hash is correct as calculated from returned payloads
                let dataHash = try PayloadBuilder.dataHash(from: payloads[i])
                XCTAssertEqual(
                    expectedPayloadHash, dataHash.toHex(),
                    "Incorrect payload hash in BW as compared to BoundWitnessBuilder returned payloads data hash"
                )
            }
            for (i, payload) in testCase.payloads.enumerated() {
                let actualSchema = bw.typedPayload.payload_schemas[i]
                // Ensure payload hash is correct
                XCTAssertEqual(payload.schema, actualSchema, "Incorrect payload schema in BW")
            }

            // Ensure correct ending account state
            for signer in signers {
                // Ensure previous hash is correct
                XCTAssertEqual(signer.previousHash, dataHash, "Incorrect previous hash for account")
            }
        }
    }
}
