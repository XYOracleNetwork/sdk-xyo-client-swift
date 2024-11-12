import Foundation

public protocol AccountInstance {
  var address: String? { get }
  var addressBytes: Data? { get }
  var previousHash: String? { get }
  func sign(hash: String) throws -> String?
}
