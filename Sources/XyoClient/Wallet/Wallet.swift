public class Wallet: WalletInstance, WalletStatic {
    public var chainCode: String
    
    public var depth: Int
    
    public var extendedKey: String
    
    public var fingerprint: String
    
    public var index: Int
    
    public var mnemonic: String?
    
    public var parentFingerprint: String
    
    public var path: String?
    
    public var privateKey: String
    
    public var publicKey: String
    
    public func derivePath(path: String) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func neuter() -> any WalletInstance {
        <#code#>
    }
    
    public func create(config: XyoPayload) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func fromExtendedKey(key: String) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func fromMnemonic(mnemonic: String) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func fromPhrase(mnemonic: String, path: String?) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func fromSeed(seed: Data) async throws -> any WalletInstance {
        <#code#>
    }
    
    public func random() -> any WalletInstance {
        <#code#>
    }
    
    public var address: Address
    
    public var addressBytes: Data
    
    public var previousHash: Hash?
    
    public func sign(hash: Hash) throws -> String {
        <#code#>
    }
    
    
}
