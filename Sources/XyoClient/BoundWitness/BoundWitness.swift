import Foundation

let BoundWitnessSchema = "network.xyo.boundwitness"

enum BoundWitnessError: Error {
    case convertionFailed
}

public class BoundWitness: Payload
{    
    public var signatures: [String]? = nil

    public var addresses: [String] = []

    public var payload_hashes: [String] = []

    public var payload_schemas: [String] = []

    public var previous_hashes: [String?] = []

    public var query: String? = nil

    init() {
        super.init(BoundWitnessSchema)
    }

    enum CodingKeys: String, CodingKey {
        case addresses
        case _hash = "$hash"
        case _meta = "$meta"
        case payload_hashes
        case payload_schemas
        case previous_hashes
        case query
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addresses = try values.decode([String].self, forKey: .addresses)
        payload_hashes = try values.decode([String].self, forKey: .payload_hashes)
        payload_schemas = try values.decode([String].self, forKey: .payload_schemas)
        previous_hashes = try values.decode([String?].self, forKey: .previous_hashes)
        query = try values.decodeIfPresent(String.self, forKey: .query)
        super.init(BoundWitnessSchema)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(addresses, forKey: .addresses)
        try container.encode(payload_hashes, forKey: .payload_hashes)
        try container.encode(payload_schemas, forKey: .payload_schemas)
        try container.encode(previous_hashes, forKey: .previous_hashes)
        try container.encodeIfPresent(query, forKey: .query)
        try super.encode(to: encoder)
    }
    
    public func toJson() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(self)
        guard let result = String(data: data, encoding: .utf8) else { throw BoundWitnessError.convertionFailed }
        return result
    }
}
