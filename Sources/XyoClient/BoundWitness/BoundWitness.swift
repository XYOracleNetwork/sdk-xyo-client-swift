import Foundation

let BoundWitnessSchema = "network.xyo.boundwitness"

public class BoundWitness: XyoPayload, XyoBoundWitnessBodyProtocol, XyoBoundWitnessMetaProtocol,
  Decodable
{

  public var _client: String? = "swift"

  public var _hash: String? = nil

  public var _signatures: [String?]? = nil

  public var _previous_hash: String? = nil

  public var addresses: [String?] = []

  public var payload_hashes: [String] = []

  public var payload_schemas: [String] = []

  public var previous_hashes: [String?] = []

  public var query: String? = nil

  init() {
    super.init(BoundWitnessSchema)
  }

  enum CodingKeys: String, CodingKey {
    case _client
    case _hash
    case _previous_hash
    case _signatures
    case addresses
    case payload_hashes
    case payload_schemas
    case previous_hashes
    case query
    case schema
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
