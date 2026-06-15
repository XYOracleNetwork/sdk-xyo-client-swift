import Foundation

/// A `ModuleInstance` backed by a `NodeClient`: issues queries to a remote XYO node and parses
/// responses. `describe()` sends a `network.xyo.query.module.manifest` query.
public final class RemoteModule: ModuleInstance {
    private let nodeClient: NodeClient
    private let _account: AccountInstance

    public var modName: String?
    public var queries: [String]

    public init(
        nodeClient: NodeClient, account: AccountInstance? = nil,
        name: String? = nil, queries: [String] = []
    ) {
        self.nodeClient = nodeClient
        self._account = account ?? Account.random()
        self.modName = name
        self.queries = queries
    }

    public convenience init(
        url: String, account: AccountInstance? = nil,
        name: String? = nil, queries: [String] = []
    ) {
        self.init(
            nodeClient: NodeClient(url: url, account: account),
            account: account, name: name, queries: queries)
    }

    // MARK: Module

    public var account: AccountInstance { _account }
    public var address: Address? { _account.address }
    public var previousHash: Hash? { _account.previousHash }

    // MARK: ModuleInstance

    @available(iOS 15, *)
    public func describe() async throws -> ModuleDescription {
        let result = try await nodeClient.query(
            EncodablePayloadInstance(QuerySchemas.moduleManifest))
        if let errors = result.errors, let first = errors.first { throw first }
        if let payload = result.response?.payloads.first {
            return try payload.decode(ModuleDescription.self)
        }
        return ModuleDescription(address: address?.toHex() ?? "")
    }

    @available(iOS 15, *)
    public func query(
        _ query: EncodablePayloadInstance, payloads: [EncodablePayloadInstance]? = nil
    ) async throws -> (EncodableBoundWitnessWithMeta?, [AnyPayload]) {
        let result = try await nodeClient.query(query, payloads: payloads)
        if let errors = result.errors, let first = errors.first { throw first }
        return (result.response?.bw, result.response?.payloads ?? [])
    }
}
