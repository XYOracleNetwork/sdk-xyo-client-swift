import Foundation

public protocol WalletInstance: AccountInstance {
  var chainCode: String { get }
  var depth: Int { get }
  var extendedKey: String { get }
  var fingerprint: String { get }
  var index: Int { get }
  var mnemonic: String? { get }
  var parentFingerprint: String { get }
  var path: String? { get }
  var privateKey: String { get }
  var publicKey: String { get }

  func derivePath(path: String) async throws -> WalletInstance
  func neuter() -> WalletInstance
}
