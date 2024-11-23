import Foundation

public class XyoBoundWitnessJson: BoundWitnessBodyJson, BoundWitnessMeta {
    enum CodingKeys: String, CodingKey {
        case _client
        case _hash
        case _signatures
        case addresses
        case payload_hashes
        case payload_schemas
        case previous_hashes
        case query
        case schema
    }

    public var _client: String?
    public var _hash: String?
    public var _signatures: [String]?
    public var _query: String?

    func encodeMetaFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(_client, forKey: ._client)
        try container.encode(_hash, forKey: ._hash)
        try container.encode(_signatures, forKey: ._signatures)
    }

    func encodeBodyFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(addresses, forKey: .addresses)
        try container.encode(payload_hashes, forKey: .payload_hashes)
        try container.encode(payload_schemas, forKey: .payload_schemas)
        try container.encode(previous_hashes, forKey: .previous_hashes)
        if query != nil {
            try container.encode(query, forKey: .query)
        }
        try container.encode(schema, forKey: .schema)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encodeMetaFields(&container)
        try encodeBodyFields(&container)
    }
}
