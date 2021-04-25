import Foundation

class XyoBoundWitnessJson : XyoBoundWitnessBodyJson {
    var signatures: [String]?
    var payloads: [Codable]?
    var client: String?
    var hash: String?
    
    enum CodingKeys: String, CodingKey {
        case addresses
        case previous_hashes
        case payload_hashes
        case payload_schemas
        case _signatures
        case _client
        case _hash
    }
    
    func encodeMetaFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(signatures, forKey: ._signatures)
        try container.encode(client, forKey: ._client)
        try container.encode(hash, forKey: ._hash)
    }
    
    func encodeBodyFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(addresses, forKey: .addresses)
        try container.encode(previousHashes, forKey: .previous_hashes)
        try container.encode(payloadHashes, forKey: .payload_hashes)
        try container.encode(payloadSchemas, forKey: .payload_schemas)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encodeBodyFields(&container)
        try encodeMetaFields(&container)
    }
}
