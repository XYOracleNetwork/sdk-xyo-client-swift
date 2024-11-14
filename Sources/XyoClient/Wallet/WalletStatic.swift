import Foundation

public protocol WalletStatic {

    //  func create(config: XyoPayload) throws -> WalletInstance
    //  func fromExtendedKey(key: String) throws -> WalletInstance
    //  func fromMnemonic(mnemonic: String) throws -> WalletInstance
    //  func fromPhrase(mnemonic: String, path: String?) throws -> WalletInstance
    //  func fromSeed(seed: Data) throws -> WalletInstance
    func random() -> WalletInstance
}
