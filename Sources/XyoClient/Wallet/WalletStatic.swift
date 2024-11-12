import Foundation

public protocol WalletStatic<T> {
  associatedtype T: WalletInstance

  func create(config: XyoPayload) async throws -> T
  func fromExtendedKey(key: String) async throws -> T
  func fromMnemonic(mnemonic: String) async throws -> T
  func fromPhrase(mnemonic: String, path: String?) async throws -> T
  func fromSeed(seed: Data) async throws -> T
  func random() -> Any
}
