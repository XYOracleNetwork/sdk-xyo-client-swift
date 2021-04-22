import Foundation

class XyoBoundWitnessJson : XyoBoundWitnessBodyJson, XyoBoundWitnessMetaJsonProtocol {
  var _signatures: [String]?
  var _payloads: [Codable]?
  var _client: String?
  var _hash: String?
  
  enum CodingKeys: String, CodingKey {
    case addresses
    case previous_hashes
    case payload_hashes
    case payload_schemas
    case _signatures
    case _client
    case _hash
  }
  
  override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(addresses, forKey: .addresses)
    try container.encode(previous_hashes, forKey: .previous_hashes)
    try container.encode(payload_hashes, forKey: .payload_hashes)
    try container.encode(payload_schemas, forKey: .payload_schemas)
    try container.encode(_signatures, forKey: ._signatures)
    try container.encode(_client, forKey: ._client)
    try container.encode(_hash, forKey: ._hash)
  }
}
