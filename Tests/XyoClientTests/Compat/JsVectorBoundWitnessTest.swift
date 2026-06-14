import XCTest

@testable import XyoClient

/// Verifies the full BoundWitness contract against the authoritative JS vectors: payload
/// hashes, signer addresses, the canonical BW dataHash, each signer's signature, and the
/// root hash (the full hash including `$signatures`).
final class JsVectorBoundWitnessTest: XCTestCase {

    override func setUp() {
        super.setUp()
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_boundWitnessVectors() throws {
        let vectors = JsCompatVectors.boundWitnesses
        XCTAssertFalse(vectors.isEmpty, "No bound_witness vectors loaded")
        for vector in vectors {
            let id = vector["id"] as? String ?? "<unknown>"
            let signerKeys = try XCTUnwrap(vector["signer_private_keys"] as? [String])
            let payloadsRawJson = try XCTUnwrap(vector["payloads_raw_json"] as? [String])
            let addresses = try XCTUnwrap(vector["addresses"] as? [String])
            let payloadHashes = try XCTUnwrap(vector["payload_hashes"] as? [String])
            let payloadSchemas = try XCTUnwrap(vector["payload_schemas"] as? [String])
            let previousHashesRaw = try XCTUnwrap(vector["previous_hashes"] as? [Any])
            let expectedDataHash = try XCTUnwrap(vector["data_hash"] as? String)
            let expectedSignatures = try XCTUnwrap(vector["signatures"] as? [String])
            let expectedRootHash = try XCTUnwrap(vector["root_hash"] as? String)

            let previousHashes: [String?] = previousHashesRaw.map { $0 is NSNull ? nil : $0 as? String }

            // (a) Each payload's dataHash from its raw JSON matches the vector.
            for (i, raw) in payloadsRawJson.enumerated() {
                let hash = try Canonicalizer
                    .canonicalJson(fromString: raw, exclusion: .allMeta)
                    .sha256().toHex()
                XCTAssertEqual(hash, payloadHashes[i], "payload hash [\(id)][\(i)]")
            }

            // (b) Each signer's derived address matches the vector.
            for (i, key) in signerKeys.enumerated() {
                let signer = try Account.fromPrivateKey(key)
                XCTAssertEqual(signer.address?.toHex(), addresses[i], "address [\(id)][\(i)]")
            }

            // (c) The reconstructed BoundWitness dataHashable form matches the vector dataHash.
            let bw = BoundWitnessInstance()
            bw.addresses = addresses
            bw.payload_hashes = payloadHashes
            bw.payload_schemas = payloadSchemas
            bw.previous_hashes = previousHashes
            let dataHash = try PayloadBuilder.dataHash(from: bw).toHex()
            XCTAssertEqual(dataHash, expectedDataHash, "BW data hash [\(id)]")

            // (d) Each signer's signature over the dataHash matches the vector.
            let dataHashBytes = try XCTUnwrap(Data(expectedDataHash))
            for (i, key) in signerKeys.enumerated() {
                let signer = try Account.fromPrivateKey(key)
                let signature = try signer.sign(dataHashBytes).toHex()
                XCTAssertEqual(signature, expectedSignatures[i], "signature [\(id)][\(i)]")
            }

            // (e) The root hash (full hash including $signatures) matches the vector.
            let meta = BoundWitnessMeta(expectedSignatures)
            let rootHash = try PayloadBuilder.hash(from: bw, meta: meta).toHex()
            XCTAssertEqual(rootHash, expectedRootHash, "BW root hash [\(id)]")
        }
    }
}
