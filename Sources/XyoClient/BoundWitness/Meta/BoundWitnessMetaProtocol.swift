import Foundation

public protocol XyoBoundWitnessMetaProtocol {
    var _client: String? { get set }
    var _hash: String? { get set }
    var _payloads: [XyoPayload]? { get set }
    var _signatures: [String?]? { get set }
    var _previous_hash: String? { get set }
}
