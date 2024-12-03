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
    public func derivePath(path: String) throws -> any WalletInstance {
        let key = try Wallet.deriveKey(from: self._key, path: path)
        return try Wallet(key: key)
    }
    
    private var _key: Key

    init(key: Key, path: String? = nil) throws {
        let newKey = try Wallet.deriveKey(from: key, path: path!)
        self._key = newKey
        super.init(newKey.privateKey)
    }
    
    convenience init(phrase: String, path: String = "m/44'/60'/0'/0/0") throws {
        let seed = try Bip39.mnemonicToSeed(phrase: phrase)
        try self.init(seed: seed, path: path)
    }
    
    convenience init(seed: Data, path: String = "m/44'/60'/0'/0/0") throws {
        let rootKey = try Bip39.rootPrivateKeyFromSeed(seed: seed)
        try self.init(key: rootKey, path: path)
    }
    
    static func generateMasterKey(seed: Data) throws -> Key {
        // The Ethereum private key is the first 32 bytes of the seed
        guard seed.count >= 32 else {
            throw WalletError.invalidSeedLength
        }

        let privateKey = seed.prefix(32)

        // Ethereum doesn't use a chain code, but you can return an empty Data if the Key struct requires it
        let chainCode = Data() // Not used for Ethereum

        return Key(privateKey: privateKey, chainCode: chainCode)
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
            let childKey = try deriveChildKey(parentKey: currentKey, index: derivedIndex)
            currentKey = childKey
        }

        return currentKey
    }

    /// Derives a child key given a parent key and an index
    private static func deriveChildKey(parentKey: Key, index: UInt32) throws -> Key {
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

        // HMAC-SHA512 with the parent chain code
        do {
            let hmac = try HMAC(key: Array(parentKey.chainCode), variant: .sha2(.sha512)).authenticate(Array(data))
            let derivedKeyData = Data(hmac)
            let derivedPrivateKey = derivedKeyData.prefix(32)
            let derivedChainCode = derivedKeyData.suffix(32)

            return Key(privateKey: derivedPrivateKey, chainCode: derivedChainCode)
        } catch {
            throw WalletError.failedToGenerateHmac
        }
    }
    
    private static func getCompressedPublicKey(privateKey: Data) -> Data {
        XyoAddress(privateKey: privateKey.toHexString()).publicKeyBytes!
    }
}
