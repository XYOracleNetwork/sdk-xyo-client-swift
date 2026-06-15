import XCTest

@testable import XyoClient

/// Offline tests for the query bound witness construction and meta handling.
final class QueryBoundWitnessTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_queryFieldIsQueryPayloadDataHash() throws {
        let signer = try Account.fromPrivateKey(
            "7f71bc5644f8f521f7e9b73f7a391e82c05432f8a9d36c44d6b1edbf1d8db62f")
        let queryPayload = ArchivistGetQueryPayload(hashes: ["abc"])
        let expectedQueryHash = try PayloadBuilder.dataHash(from: queryPayload).toHex()

        let (bw, payloads) = try QueryBoundWitnessBuilder()
            .signer(signer)
            .query(queryPayload)
            .build()

        XCTAssertEqual(bw.typedPayload.query, expectedQueryHash, "query field must be the query dataHash")
        // The query payload is appended to the payloads and its schema recorded.
        XCTAssertEqual(payloads.count, 1)
        XCTAssertEqual(bw.typedPayload.payload_schemas, [ArchivistGetQueryPayload.schema])
    }

    func test_clientMetaDoesNotChangeDataHash() throws {
        let signer = try Account.fromPrivateKey(
            "7f71bc5644f8f521f7e9b73f7a391e82c05432f8a9d36c44d6b1edbf1d8db62f")
        let query = EncodablePayloadInstance(QuerySchemas.archivistAll)

        let (plain, _) = try QueryBoundWitnessBuilder().signer(signer).query(query).build()
        let plainHash = try PayloadBuilder.dataHash(from: plain.typedPayload).toHex()

        Account.previousHashStore = MemoryPreviousHashStore()
        let signer2 = try Account.fromPrivateKey(
            "7f71bc5644f8f521f7e9b73f7a391e82c05432f8a9d36c44d6b1edbf1d8db62f")
        let (withMeta, _) = try QueryBoundWitnessBuilder()
            .signer(signer2)
            .sourceQuery("deadbeef")
            .destination("5e7a847447e7fec41011ae7d32d768f86605ba03")
            .query(query)
            .build()
        let metaHash = try PayloadBuilder.dataHash(from: withMeta.typedPayload).toHex()

        XCTAssertEqual(plainHash, metaHash, "$sourceQuery/$destination must not affect the data hash")
        XCTAssertEqual(withMeta.typedMeta?.sourceQuery, "deadbeef")
        XCTAssertEqual(withMeta.typedMeta?.destination, "5e7a847447e7fec41011ae7d32d768f86605ba03")
    }
}
