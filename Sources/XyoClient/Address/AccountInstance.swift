import Foundation

public protocol AccountInstance {
  var address: Address { get }
  var addressBytes: Data { get }
  var previousHash: Hash? { get set }
  // var previousHashBytes: Data? { get set }
  // var `private`: Data? { get }
  // var `public`: Data? { get }

  func sign(hash: Data) async throws -> Data
  // func sign(hash: Data, previousHash: Data?) async throws -> Data
  // func verify(msg: Data, signature: Data) async throws -> Bool
}
