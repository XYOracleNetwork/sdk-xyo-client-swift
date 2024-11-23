import Foundation

public protocol BoundWitnessBody {
    var addresses: [String] { get set }
    var payload_hashes: [String] { get set }
    var payload_schemas: [String] { get set }
    var previous_hashes: [String?] { get set }
    var query: String? { get set }
}
