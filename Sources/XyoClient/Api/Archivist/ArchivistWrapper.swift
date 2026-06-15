import Foundation

/// Convenience layer over a `NodeClient` for issuing Archivist queries, matching the Android
/// `ArchivistWrapper`. Each method builds the corresponding `network.xyo.query.archivist.*`
/// query payload and dispatches it through the node client.
public final class ArchivistWrapper {
    private let nodeClient: NodeClient

    public init(nodeClient: NodeClient) {
        self.nodeClient = nodeClient
    }

    public convenience init(url: String, account: AccountInstance? = nil) {
        self.init(nodeClient: NodeClient(url: url, account: account))
    }

    @available(iOS 15, *)
    public func get(_ hashes: [String]) async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistGetQueryPayload(hashes: hashes))
    }

    @available(iOS 15, *)
    public func insert(_ payloads: [EncodablePayloadInstance]) async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistInsertQueryPayload(), payloads: payloads)
    }

    @available(iOS 15, *)
    public func delete(_ hashes: [String]) async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistDeleteQueryPayload(hashes: hashes))
    }

    @available(iOS 15, *)
    public func all() async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistAllQueryPayload())
    }

    @available(iOS 15, *)
    public func clear() async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistClearQueryPayload())
    }

    @available(iOS 15, *)
    public func next(
        cursor: String? = nil, limit: Int? = nil, open: Bool? = nil, order: String? = nil
    ) async throws -> PostQueryResult {
        try await nodeClient.query(
            ArchivistNextQueryPayload(cursor: cursor, limit: limit, open: open, order: order))
    }

    @available(iOS 15, *)
    public func commit() async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistCommitQueryPayload())
    }

    @available(iOS 15, *)
    public func snapshot() async throws -> PostQueryResult {
        try await nodeClient.query(ArchivistSnapshotQueryPayload())
    }
}
