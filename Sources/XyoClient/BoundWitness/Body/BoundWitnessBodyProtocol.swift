import Foundation

public protocol XyoBoundWitnessBodyProtocol {
    var addresses: [String?] { get set }
    var payload_hashes: [String] { get set }
    var payload_schemas: [String] { get set }
    var previous_hashes: [String?] { get set }
}
