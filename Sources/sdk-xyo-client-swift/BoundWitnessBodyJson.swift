import Foundation

class XyoBoundWitnessBodyJson: Codable {
  var addresses: [String] = []
  var previousHashes: [String?] = []
  var payloadHashes: [String] = []
  var payloadSchemas: [String] = []
  
  init (_ addresses: [String], _ previousHashes: [String?], _ payloadHashes: [String], _ payloadSchemas: [String]) {
    self.addresses = addresses
    self.previousHashes = previousHashes
    self.payloadHashes = payloadHashes
    self.payloadSchemas = payloadSchemas
  }
  
  enum CodingKeys: String, CodingKey {
    case addresses
    case previous_hashes
    case payload_hashes
    case payload_schemas
  }
  
  func encodeBodyFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
    try container.encode(addresses, forKey: .addresses)
    try container.encode(previousHashes, forKey: .previous_hashes)
    try container.encode(payloadHashes, forKey: .payload_hashes)
    try container.encode(payloadSchemas, forKey: .payload_schemas)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try encodeBodyFields(&container)
  }
  
  required init() {}
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    addresses = try values.decode([String].self, forKey: .addresses)
    previousHashes = try values.decode([String?].self, forKey: .previous_hashes)
    payloadHashes = try values.decode([String].self, forKey: .payload_hashes)
    payloadSchemas = try values.decode([String].self, forKey: .payload_schemas)
  }
  
}

