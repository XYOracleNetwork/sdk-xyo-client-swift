import Foundation

/// Discoverable metadata about a module, matching the Android/JS `ModuleDescription`.
public struct ModuleDescription: Codable, Equatable {
    /// The module's address (hex string).
    public let address: String
    /// Optional human-readable name.
    public let name: String?
    /// Query schemas this module supports.
    public let queries: [String]
    /// Child module addresses (for nodes).
    public let children: [String]

    public init(address: String, name: String? = nil, queries: [String] = [], children: [String] = []) {
        self.address = address
        self.name = name
        self.queries = queries
        self.children = children
    }

    enum CodingKeys: String, CodingKey {
        case address, name, queries, children
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = (try? container.decode(String.self, forKey: .address)) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name)
        queries = (try? container.decode([String].self, forKey: .queries)) ?? []
        children = (try? container.decode([String].self, forKey: .children)) ?? []
    }
}
