import Foundation

public protocol WalletStatic {

    //  static func fromExtendedKey(key: String) throws -> WalletInstance
    static func fromMnemonic(mnemonic: String, path: String?) throws -> WalletInstance
    //  static func random() -> WalletInstance
}
