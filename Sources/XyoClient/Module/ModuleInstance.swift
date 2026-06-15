import Foundation

/// Module lifecycle status, matching the Android/JS `ModuleStatus`.
public enum ModuleStatus: String {
    case creating, created, starting, started, stopping, stopped, error, wrapped, proxy
}

/// Base module interface matching the Android/JS `ModuleInstance`. All XYO module types
/// (Witness, Diviner, Archivist, Sentinel, Bridge, Node) provide a uniform query API.
public protocol ModuleInstance: Module {
    /// Optional human-readable name.
    var modName: String? { get }
    /// Query schemas this module supports.
    var queries: [String] { get }
    /// The current module status.
    var status: ModuleStatus? { get }

    /// Fetch a description of this module.
    @available(iOS 15, *)
    func describe() async throws -> ModuleDescription

    /// Send a query to this module, returning the resulting bound witness and response payloads.
    @available(iOS 15, *)
    func query(_ query: EncodablePayloadInstance, payloads: [EncodablePayloadInstance]?) async throws
        -> (EncodableBoundWitnessWithMeta?, [AnyPayload])
}

extension ModuleInstance {
    public var modName: String? { nil }
    public var status: ModuleStatus? { nil }

    /// The module's identifier: `modName` if set, otherwise the address hex.
    public var id: String { modName ?? (address?.toHex() ?? "") }

    /// Whether this module supports the given query schema.
    public func isSupportedQuery(_ schema: String) -> Bool { queries.contains(schema) }
}
