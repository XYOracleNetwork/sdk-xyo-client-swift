import Foundation

class XyoBoundWitnessJson : XyoBoundWitnessBodyJson, XyoBoundWitnessMetaJsonProtocol {
  var _signatures: [String]?
  var _payloads: [Codable]?
  var _client: String?
  var _hash: String?
}
