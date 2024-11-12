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

public protocol WalletStatic<T> {
    associatedtype T: WalletInstance
    
    func create(config: XyoPayload) async throws -> T
    func fromExtendedKey(key: String) async throws -> T
    func fromMnemonic(mnemonic: String) async throws -> T
    func fromPhrase(mnemonic: String, path: String?) async throws -> T
    func fromSeed(seed: Data) async throws -> T
    func random() -> Any
}
