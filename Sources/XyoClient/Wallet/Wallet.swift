import Foundation
import CryptoKit
import CryptoSwift
import BigInt
import secp256k1

public struct Key {
    let privateKey: Data
    let chainCode: Data
}

public enum WalletError: Error {
    case failedToGetPublicKey
    case failedToDervivePath
    case invalidSeed
    case invalidPath
    case invalidPathComponent
    case invalidSeedLength
    case failedToGenerateHmac
    case invalidPrivateKeyLength
}

public class Wallet: Account, WalletInstance {
    
    static let defaultPath = "m/44'/60'/0'/0/0"
    
    public func derivePath(path: String) throws -> any WalletInstance {
        let key = try Wallet.deriveKey(from: self._key, path: path)
        return try Wallet(key: key)
    }
    
    private var _key: Key

    init(key: Key) throws {
        self._key = key
        super.init(key.privateKey)
    }
    
    convenience init(phrase: String, path: String = defaultPath) throws {
        let seed = try Bip39.mnemonicToSeed(phrase: phrase)
        try self.init(seed: seed, path: path)
    }
    
    convenience init(seed: Data, path: String = defaultPath) throws {
        let rootKey = try Bip39.rootPrivateKeyFromSeed(seed: seed)
        let derivedKey = try Wallet.deriveKey(from: rootKey, path: path)
        try self.init(key: derivedKey)
    }
    
    static func deriveKey(from parentKey: Key, path: String) throws -> Key {
        let components = path.split(separator: "/")
        
        guard components.first == "m" else {
            throw WalletError.invalidPath
        }

        var currentKey = parentKey
        for component in components.dropFirst() {
            let hardened = component.last == "'"
            let indexString = hardened ? component.dropLast() : component
            guard let index = UInt32(indexString) else {
               throw WalletError.invalidPathComponent
            }

            let derivedIndex = hardened ? index | 0x80000000 : index
            let childKey = deriveChildKey(parentKey: currentKey, index: derivedIndex)
            currentKey = childKey
        }

        return currentKey
    }

    /// Derives a child key given a parent key and an index
    private static func deriveChildKey(parentKey: Key, index: UInt32) -> Key {
        var data = Data()

        if index >= 0x80000000 {
            // Hardened key: prepend 0x00 and parent private key
            data.append(0x00)
            data.append(parentKey.privateKey)
        } else {
            // Normal key: use the public key
            let publicKey = getCompressedPublicKey(privateKey: parentKey.privateKey)
            data.append(publicKey)
        }

        // Append the index
        data.append(contentsOf: withUnsafeBytes(of: index.bigEndian, Array.init))

        let hmac = Hmac.hmacSha512(key: parentKey.chainCode, data: data)
        let derivedKeyData = Data(hmac)
        let derivedPrivateKey = derivedKeyData.prefix(32)
        let derivedChainCode = derivedKeyData.suffix(32)

        return Key(privateKey: derivedPrivateKey, chainCode: derivedChainCode)
    }
    
    private static func getCompressedPublicKey(privateKey: Data) -> Data {
        XyoAddress(privateKey: privateKey.toHexString()).publicKeyBytes!
    }
}
