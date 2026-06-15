import XCTest

@testable import XyoClient

/// Offline tests for decoding a node/archivist query response into `ModuleQueryResult` /
/// `AnyPayload`, and for the Archivist query payload encodings.
final class QueryResponseDecodingTests: XCTestCase {

    func test_decodeModuleQueryResultWithHeterogeneousPayloads() throws {
        let json = """
            {"data":[
              {"addresses":["5e7a847447e7fec41011ae7d32d768f86605ba03"],
               "payload_hashes":["20e14207f952a09f767ff614a648546c037fe524ace0bfe55db31f818aff1f1c"],
               "payload_schemas":["network.xyo.test"],
               "previous_hashes":[null],
               "schema":"network.xyo.boundwitness",
               "$signatures":["95100e5fd2012b958e96895870cfac5353c3a33a19314cfd1304ef7d01d052ec"]},
              [{"schema":"network.xyo.test","value":"hello"},{"schema":"network.xyo.id","salt":"42"}],
              []
            ]}
            """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let envelope = try JSONDecoder().decode(
            ApiResponseEnvelope<ModuleQueryResult>.self, from: data)
        let result = try XCTUnwrap(envelope.data)

        XCTAssertEqual(result.bw.typedPayload.addresses, ["5e7a847447e7fec41011ae7d32d768f86605ba03"])
        XCTAssertEqual(result.payloads.count, 2)

        let first = try XCTUnwrap(result.payloads.first as? AnyPayload)
        XCTAssertEqual(first.schema, "network.xyo.test")
        XCTAssertEqual(first.string("value"), "hello")

        let second = try XCTUnwrap(result.payloads.last as? AnyPayload)
        XCTAssertEqual(second.schema, "network.xyo.id")
        XCTAssertEqual(second.string("salt"), "42")
    }

    func test_archivistQueryPayloadEncodings() throws {
        try assertEncodes(ArchivistGetQueryPayload(hashes: ["a", "b"]),
            schema: "network.xyo.query.archivist.get",
            extra: ["hashes": .array([.string("a"), .string("b")])])
        try assertEncodes(ArchivistInsertQueryPayload(),
            schema: "network.xyo.query.archivist.insert")
        try assertEncodes(ArchivistNextQueryPayload(cursor: "c", limit: 5),
            schema: "network.xyo.query.archivist.next",
            extra: ["cursor": .string("c"), "limit": .int(5)])
        try assertEncodes(ArchivistAllQueryPayload(), schema: "network.xyo.query.archivist.all")
    }

    private func assertEncodes(
        _ payload: EncodablePayloadInstance, schema: String, extra: [String: JSONValue] = [:]
    ) throws {
        let data = try JSONEncoder().encode(payload)
        let object = try JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["schema"], .string(schema))
        for (key, value) in extra {
            XCTAssertEqual(object[key], value, "field \(key) mismatch")
        }
    }
}
