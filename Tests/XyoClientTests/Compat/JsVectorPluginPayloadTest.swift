import XCTest

@testable import XyoClient

/// Verifies that the typed Swift payload classes serialize to JS-identical canonical JSON by
/// constructing each plugin payload and comparing its `dataHash`/`hash` to the vector.
final class JsVectorPluginPayloadTest: XCTestCase {

    private func assertPlugin(_ id: String, _ payload: EncodablePayloadInstance) throws {
        let vector = try XCTUnwrap(JsCompatVectors.payloadHash(id: id), "missing vector \(id)")
        let expectedDataHash = try XCTUnwrap(vector["data_hash"] as? String)
        let expectedHash = try XCTUnwrap(vector["hash"] as? String)

        let dataHash = try PayloadBuilder.dataHash(from: payload).toHex()
        XCTAssertEqual(dataHash, expectedDataHash, "data_hash mismatch for [\(id)]")

        let hash = try PayloadBuilder.hash(from: payload).toHex()
        XCTAssertEqual(hash, expectedHash, "hash mismatch for [\(id)]")
    }

    func test_pluginPayloadVectors() throws {
        try assertPlugin(
            "plugin-address",
            AddressPayload(
                address: "1234567890abcdef1234567890abcdef12345678", name: "primary-signer"))

        try assertPlugin(
            "plugin-config",
            ConfigPayload(config: [
                "timeout": 30, "retries": 3, "enabled": true, "label": "test-config"
            ]))

        try assertPlugin(
            "plugin-domain",
            DomainPayload(
                domain: "xyo.network",
                aliases: ["primary": "xyo.network", "cdn": "cdn.xyo.network"]))

        try assertPlugin("plugin-id", IdPayload("cross-sdk-id-vector"))

        try assertPlugin(
            "plugin-schema",
            SchemaPayload(definition: ["title": "test", "version": 1, "fields": ["a", "b", "c"]]))

        try assertPlugin("plugin-value-number", ValuePayload(value: 42))
        try assertPlugin("plugin-value-string", ValuePayload(value: "hello-value-plugin"))
        try assertPlugin("plugin-value-object", ValuePayload(value: ["key": "nested", "n": 99]))
    }
}
