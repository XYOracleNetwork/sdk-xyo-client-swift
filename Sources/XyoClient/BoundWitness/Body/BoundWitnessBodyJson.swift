import Foundation

public class XyoBoundWitnessBodyJson: XyoBoundWitnessBodyProtocol, Encodable, Decodable {
    enum CodingKeys: String, CodingKey {
        case addresses
        case payload_hashes
        case payload_schemas
        case previous_hashes
        case query
        case schema
    }

    public var addresses: [String] = []
    public var payload_hashes: [String] = []
    public var payload_schemas: [String] = []
    public var previous_hashes: [String?] = []
    public var query: String?
    public var schema: String

    init(
        _ addresses: [String],
        _ previous_hashes: [String?],
        _ payload_hashes: [String],
        _ payload_schemas: [String],
        _ query: String? = nil
    ) {
        self.addresses = addresses
        self.payload_hashes = payload_hashes
        self.payload_schemas = payload_schemas
        self.previous_hashes = previous_hashes
        self.query = query
        self.schema = "network.xyo.boundwitness"
    }

    required init() {
        self.schema = "network.xyo.boundwitness"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addresses = try values.decode([String].self, forKey: .addresses)
        payload_hashes = try values.decode([String].self, forKey: .payload_hashes)
        payload_schemas = try values.decode([String].self, forKey: .payload_schemas)
        previous_hashes = try values.decode([String?].self, forKey: .previous_hashes)
        query = try values.decode(String?.self, forKey: .query)
        self.schema = "network.xyo.boundwitness"
    }

    func encodeBodyFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(addresses, forKey: .addresses)
        try container.encode(payload_hashes, forKey: .payload_hashes)
        try container.encode(payload_schemas, forKey: .payload_schemas)
        try container.encode(previous_hashes, forKey: .previous_hashes)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encode(schema, forKey: .schema)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encodeBodyFields(&container)
    }
}
