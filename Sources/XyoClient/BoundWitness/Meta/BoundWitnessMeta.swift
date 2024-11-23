import Foundation

public protocol BoundWitnessMeta {
    var _client: String? { get set }
    var _hash: String? { get set }
    var _signatures: [String]? { get set }
}
