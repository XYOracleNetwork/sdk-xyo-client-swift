import Foundation

typealias XyoBoundWitnessJsonProtocol = XyoBoundWitnessBodyJsonProtocol & XyoBoundWitnessMetaJsonProtocol

class XyoBoundWitnessJson<T: Codable> : XyoBoundWitnessBodyJson<T>, XyoBoundWitnessMetaJsonProtocol {
  var _hash: String! = nil
  var _signatures: [String]! = nil
}
