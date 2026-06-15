import Foundation

let BoundWitnessSchema = "network.xyo.boundwitness"

public protocol BoundWitnessFields {
    var addresses: [String] { get }
    var payload_hashes: [String] { get }
    var payload_schemas: [String] { get }
    var previous_hashes: [String?] { get }
}

public protocol EncodableBoundWitness: EncodablePayload, BoundWitnessFields, Encodable {}

public protocol BoundWitness: EncodableBoundWitness, EncodablePayload, Payload, Codable {}

public class BoundWitnessInstance: PayloadInstance {
    public var signatures: [String]?

    public var addresses: [String] = []

    public var payload_hashes: [String] = []

    public var payload_schemas: [String] = []

    public var previous_hashes: [String?] = []

    /// The dataHash of the query payload (query bound witnesses only). Data-hashable (signed).
    public var query: String?

    /// Hashes of error payloads, if any. Data-hashable (signed).
    public var error_hashes: [String]?

    init() {
        super.init(BoundWitnessSchema)
    }

    enum CodingKeys: String, CodingKey {
        case addresses
        case payload_hashes
        case payload_schemas
        case previous_hashes
        case query
        case error_hashes
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addresses = try values.decode([String].self, forKey: .addresses)
        payload_hashes = try values.decode([String].self, forKey: .payload_hashes)
        payload_schemas = try values.decode([String].self, forKey: .payload_schemas)
        previous_hashes = try values.decode([String?].self, forKey: .previous_hashes)
        query = try values.decodeIfPresent(String.self, forKey: .query)
        error_hashes = try values.decodeIfPresent([String].self, forKey: .error_hashes)
        super.init(BoundWitnessSchema)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(addresses, forKey: .addresses)
        try container.encode(payload_hashes, forKey: .payload_hashes)
        try container.encode(payload_schemas, forKey: .payload_schemas)
        try container.encode(previous_hashes, forKey: .previous_hashes)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(error_hashes, forKey: .error_hashes)
        try super.encode(to: encoder)
    }
}

public typealias EncodableBoundWitnessWithMeta = EncodableWithCustomMetaInstance<
    BoundWitnessInstance, BoundWitnessMeta
>

public typealias BoundWitnessWithMeta = WithCustomMetaInstance<
    BoundWitnessInstance, BoundWitnessMeta
>
