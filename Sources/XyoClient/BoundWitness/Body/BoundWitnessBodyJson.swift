import Foundation

public class XyoBoundWitnessBodyJson: XyoBoundWitnessBodyProtocol, Codable {
  enum CodingKeys: String, CodingKey {
    case addresses
    case previous_hashes
    case payload_hashes
    case payload_schemas
  }
  
  public var addresses: [String] = []
  public var previous_hashes: [String?] = []
  public var payload_hashes: [String] = []
  public var payload_schemas: [String] = []
  
  init (_ addresses: [String], _ previous_hashes: [String?], _ payload_hashes: [String], _ payload_schemas: [String]) {
    self.addresses = addresses
    self.previous_hashes = previous_hashes
    self.payload_hashes = payload_hashes
    self.payload_schemas = payload_schemas
  }
  
  required init() {}
  
  public required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    addresses = try values.decode([String].self, forKey: .addresses)
    previous_hashes = try values.decode([String?].self, forKey: .previous_hashes)
    payload_hashes = try values.decode([String].self, forKey: .payload_hashes)
    payload_schemas = try values.decode([String].self, forKey: .payload_schemas)
  }
  
  func encodeBodyFields(_ container: inout KeyedEncodingContainer<CodingKeys>) throws {
    try container.encode(addresses, forKey: .addresses)
    try container.encode(previous_hashes, forKey: .previous_hashes)
    try container.encode(payload_hashes, forKey: .payload_hashes)
    try container.encode(payload_schemas, forKey: .payload_schemas)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try encodeBodyFields(&container)
  }
}
