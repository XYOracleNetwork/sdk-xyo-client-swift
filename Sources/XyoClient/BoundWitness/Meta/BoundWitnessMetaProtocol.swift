import Foundation

public protocol XyoBoundWitnessMetaProtocol {
    var _hash: String? { get set }
    var _signatures: [String]? { get set }
    var _payloads: [Codable]? { get set }
    var _client: String? { get set }
}
