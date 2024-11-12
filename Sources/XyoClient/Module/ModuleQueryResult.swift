import Foundation

public class ModuleQueryResult: Encodable, Decodable {
  var bw: XyoBoundWitnessJson
  var payloads: [XyoPayload]
  var errors: [XyoPayload]
  init(bw: XyoBoundWitnessJson, payloads: [XyoPayload] = [], errors: [XyoPayload] = []) {
    self.bw = bw
    self.payloads = payloads
    self.errors = errors
  }
  public func encode(to encoder: Encoder) throws {
    // Create an unkeyed container for array encoding
    var container = encoder.unkeyedContainer()
    // Encode `bw` as the first element
    try container.encode(bw)
    // Encode `payloads` as the second element
    try container.encode(payloads)
    // Encode `errors` as the third element
    try container.encode(errors)
  }
  public required init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    // Decode elements in the expected order from the array
    bw = try container.decode(XyoBoundWitnessJson.self)
    // TODO: Decodable Payloads
    // payloads = try container.decode([XyoPayload].self)
    // errors = try container.decode([XyoPayload].self)
    payloads = []
    errors = []
  }
}
