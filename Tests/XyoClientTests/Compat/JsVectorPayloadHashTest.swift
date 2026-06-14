import XCTest

@testable import XyoClient

/// Verifies the canonical-JSON + SHA-256 pipeline against the authoritative JS `ObjectHasher`
/// output. Feeds each vector's raw JSON string through ``Canonicalizer`` and compares the
/// `dataHash` (`$` and `_` meta stripped at top level) and `hash` (only `_` stripped).
final class JsVectorPayloadHashTest: XCTestCase {

    func test_payloadHashVectors() throws {
        let vectors = JsCompatVectors.payloadHashes
        XCTAssertFalse(vectors.isEmpty, "No payload_hashes vectors loaded")
        for vector in vectors {
            let id = vector["id"] as? String ?? "<unknown>"
            let rawJson = try XCTUnwrap(vector["raw_json"] as? String, "raw_json missing for \(id)")
            let expectedDataHash = try XCTUnwrap(vector["data_hash"] as? String)
            let expectedHash = try XCTUnwrap(vector["hash"] as? String)

            let dataHash = try Canonicalizer
                .canonicalJson(fromString: rawJson, exclusion: .allMeta)
                .sha256().toHex()
            let hash = try Canonicalizer
                .canonicalJson(fromString: rawJson, exclusion: .storageMeta)
                .sha256().toHex()

            XCTAssertEqual(dataHash, expectedDataHash, "data_hash mismatch for [\(id)]")
            XCTAssertEqual(hash, expectedHash, "hash mismatch for [\(id)]")
        }
    }
}
