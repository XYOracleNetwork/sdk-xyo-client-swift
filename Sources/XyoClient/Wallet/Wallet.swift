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
    case failedToDerivePath
    case invalidSeed
    case invalidPath
    case invalidPathComponent
    case invalidSeedLength
    case failedToGenerateHmac
    case invalidPrivateKeyLength
    case invalidChildKey
    case missingPrivateKey
    case missingPublicKey
}

public class Wallet: Account, WalletInstance {
    
    static let defaultPath = "m/44'/60'/0'/0/0"
    
    // Define the secp256k1 curve order
    static let secp256k1CurveOrder = BigInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16)!

    
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
            currentKey = try deriveChildKey(parentKey: currentKey, index: derivedIndex)
        }

        return currentKey
    }

    /// Derives a child key given a parent key and an index
    private static func deriveChildKey(parentKey: Key, index: UInt32) throws -> Key {
        var data = Data()

        if index >= 0x80000000 {
            // Hardened key: prepend 0x00 and parent private key
            guard parentKey.privateKey.count == 32 else {
                throw WalletError.invalidPrivateKeyLength
            }
            data.append(0x00)
            data.append(parentKey.privateKey)
        } else {
            // Normal key: use the compressed public key
            guard let publicKey = try? getCompressedPublicKey(privateKey: parentKey.privateKey) else {
                throw WalletError.failedToGetPublicKey
            }
            let val = publicKey.toHex()
            data.append(publicKey)
        }

        // Append the index
        data.append(contentsOf: withUnsafeBytes(of: index.bigEndian, Array.init))
        
        // Perform HMAC-SHA512
        guard data.count == 37 else {
            throw WalletError.failedToGenerateHmac
        }
        let hmac = Hmac.hmacSha512(key: parentKey.chainCode, data: data)
        let derivedPrivateKey = hmac.prefix(32)
        let derivedChainCode = hmac.suffix(32)

        // Validate the derived private key
        guard BigInt(Data(derivedPrivateKey)) < secp256k1CurveOrder else {
            throw WalletError.invalidChildKey
        }

        return Key(privateKey: derivedPrivateKey, chainCode: derivedChainCode)
    }
    
    private static func getCompressedPublicKey(privateKey: Data) throws -> Data {
        guard let uncompressedKey = XyoAddress(privateKey: privateKey.toHexString()).publicKeyBytes else {
            throw WalletError.failedToGetPublicKey
        }
//        return publicKeyBytes
        // Ensure the input key is exactly 64 bytes
        guard uncompressedKey.count == 64 else {
            throw WalletError.invalidPrivateKeyLength
        }
        
        // Extract x and y coordinates
        let x = uncompressedKey.prefix(32) // First 32 bytes are x
        let y = uncompressedKey.suffix(32) // Last 32 bytes are y
        
        // Convert y to an integer to determine parity
        let yInt = BigInt(Data(y))
        let isEven = yInt % 2 == 0
        
        // Determine the prefix based on the parity of y
        let prefix: UInt8 = isEven ? 0x02 : 0x03
        
        // Construct the compressed key: prefix + x
        var compressedKey = Data([prefix]) // Start with the prefix
        compressedKey.append(x)            // Append the x-coordinate
        
        let test = compressedKey.toHexString()
        return compressedKey
    }
}
