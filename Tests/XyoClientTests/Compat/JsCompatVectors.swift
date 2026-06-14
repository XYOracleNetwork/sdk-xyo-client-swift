import Foundation
import XCTest

/// Loader for the shared cross-SDK test vectors generated from the authoritative JS SDKs
/// (see `xl1-compat/generate-vectors.mjs`). The JSON is bundled as a test resource and
/// parsed once via `JSONSerialization` so that `raw_json` strings are preserved verbatim for
/// the canonicalization tests.
enum JsCompatVectors {

    static let root: [String: Any] = {
        guard let url = Bundle.module.url(forResource: "jsCompatVectors", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            fatalError(
                "Missing or invalid jsCompatVectors.json — regenerate via xl1-compat/generate-vectors.mjs")
        }
        return object
    }()

    static var accounts: [[String: Any]] { root["accounts"] as? [[String: Any]] ?? [] }
    static var hdWallets: [[String: Any]] { root["hd_wallets"] as? [[String: Any]] ?? [] }
    static var payloadHashes: [[String: Any]] { root["payload_hashes"] as? [[String: Any]] ?? [] }
    static var boundWitnesses: [[String: Any]] { root["bound_witnesses"] as? [[String: Any]] ?? [] }
    static var xl1Amounts: [[String: Any]] { root["xl1_amounts"] as? [[String: Any]] ?? [] }

    /// Look up a payload-hash vector by its `id`.
    static func payloadHash(id: String) -> [String: Any]? {
        payloadHashes.first { ($0["id"] as? String) == id }
    }
}
