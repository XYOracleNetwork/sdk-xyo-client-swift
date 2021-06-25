import Foundation
import CryptoKit

public class XyoAddress {
    
    private var _privateKey: Any?
    
    public var privateKey: String? {
        get {
            if #available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *) {
                let pk = self._privateKey as? P256.Signing.PrivateKey
                return pk?.rawRepresentation.toHex()
            } else {
                let pk = self._privateKey as? Data
                return pk?.toHex()
            }
        }
    }
    
    public var publicKey: String? {
        get {
            if #available(iOS 13.0, macOS 11.0, watchOS 6.0, tvOS 13.0, *) {
                guard let pk = self._privateKey as? P256.Signing.PrivateKey else {return nil}
                let fullPk = pk.publicKey.rawRepresentation.toHex()
                return String(fullPk.prefix(64))
            } else {
                let pk = self._privateKey as? Data
                return pk?.toHex()
            }
        }
    }
    
    public init() throws {
        if let generatedPrivateKey = try self.generatePrivateKey() {
            self._privateKey = generatedPrivateKey
        }
    }
    
    public init(key: Data) throws {
        if let generatedPrivateKey = try self.generatePrivateKey(key) {
            self._privateKey = generatedPrivateKey
        }
    }
    
    public init(key: String) throws {
        if let keyData = key.data(using: .hexadecimal) {
            if let generatedPrivateKey = try self.generatePrivateKey(keyData) {
                self._privateKey = generatedPrivateKey
            }
        }
    }
    
    public convenience init(phrase: String) throws {
        if let key = phrase.data(using: String.Encoding.utf8)?.sha256() {
            try self.init(key: key as Data)
        } else {
            throw XyoAddressError.invalidPrivateKey
        }
    }
    
    public func sign(_ hash: String) throws -> Data {
        if let hashData = hash.data(using: String.Encoding.utf8) {
            if #available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *) {
                let pk = self._privateKey as? P256.Signing.PrivateKey
                if let signature = try pk?.signature(for: hashData) {
                    return signature.rawRepresentation
                } else {
                    throw XyoAddressError.signingFailed
                }
            } else {
                return Data(bytes: "unsigned", count: 8)
            }
        } else {
            throw XyoAddressError.invalidHash
        }
    }
    
    private func generateRandomBytes() -> Data? {

        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    
    private func generatePrivateKey() throws -> Any? {
        if #available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *) {
            return P256.Signing.PrivateKey()
        } else {
            return generateRandomBytes()
        }
    }
    
    private func generatePrivateKey(_ privateKey: Data) throws -> Any? {
        if (privateKey.count != 32) {
            throw XyoAddressError.invalidPrivateKeyLength
        }
        do {
            if #available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *) {
                return try privateKey.withUnsafeBytes { ptr in
                    return try P256.Signing.PrivateKey(rawRepresentation: ptr)
                }
            } else {
                return privateKey
            }
        } catch {
            throw XyoAddressError.invalidPrivateKey
        }
    }
}
