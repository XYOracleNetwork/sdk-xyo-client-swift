import Foundation

protocol XyoBoundWitnessBodyJsonProtocol {
  var addresses : [String] {get set}
  var hashes : [String?] {get set}
}

class XyoBoundWitnessBodyJson<T: Codable> : XyoBoundWitnessBodyJsonProtocol, Codable {
  var addresses: [String] = []
  var hashes: [String?] = []
  var payload: T! = nil
  
  enum CodingKeys: String, CodingKey {
      case addresses
      case hashes
      case payload
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(addresses, forKey: .addresses)
    try container.encode(hashes, forKey: .hashes)
    try container.encode(payload, forKey: .payload)
  }
  
  required init() {}
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    addresses = try values.decode([String].self, forKey: .addresses)
    hashes = try values.decode([String?].self, forKey: .hashes)
    payload = try values.decode(T.self, forKey: .payload)
  }
  
}

