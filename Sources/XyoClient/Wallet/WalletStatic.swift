import Foundation

public protocol WalletStatic {

  func create(config: XyoPayload) async throws -> WalletInstance
  func fromExtendedKey(key: String) async throws -> WalletInstance
  func fromMnemonic(mnemonic: String) async throws -> WalletInstance
  func fromPhrase(mnemonic: String, path: String?) async throws -> WalletInstance
  func fromSeed(seed: Data) async throws -> WalletInstance
  func random() -> WalletInstance
}
