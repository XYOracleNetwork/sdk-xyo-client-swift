import Foundation

/// Loader for the shared cross-SDK test vectors (see `xl1-compat/generate-vectors.mjs`),
/// bundled into the `XyoChainProtocolTests` target. Duplicated from the `XyoClientTests`
/// loader because each SwiftPM test target has its own `Bundle.module`.
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

    static var xl1Amounts: [[String: Any]] { root["xl1_amounts"] as? [[String: Any]] ?? [] }
}
