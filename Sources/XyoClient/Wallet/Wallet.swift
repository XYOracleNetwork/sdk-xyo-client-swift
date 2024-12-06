import BigInt
import CryptoKit
import CryptoSwift
import Foundation
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

public class Wallet: Account, WalletInstance, WalletStatic {

    static let defaultPath = "m/44'/60'/0'/0/0"

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

    public static func fromMnemonic(mnemonic: String, path: String?) throws -> any WalletInstance {
        return try Wallet(phrase: mnemonic, path: path ?? Wallet.defaultPath)
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

            let derivedIndex = hardened ? index | 0x8000_0000 : index
            currentKey = try deriveChildKey(parentKey: currentKey, index: derivedIndex)
        }

        return currentKey
    }

    /// Derives a child key given a parent key and an index
    private static func deriveChildKey(parentKey: Key, index: UInt32) throws -> Key {
        var data = Data()

        if index >= 0x8000_0000 {
            // Hardened key: prepend 0x00 and parent private key
            guard parentKey.privateKey.count == 32 else {
                throw WalletError.invalidPrivateKeyLength
            }
            data.append(0x00)
            data.append(parentKey.privateKey)
        } else {
            // Append the compressed public key
            guard
                let publicKey = try? Wallet.getCompressedPublicKeyFrom(
                    privateKey: parentKey.privateKey)
            else {
                throw WalletError.failedToGetPublicKey
            }
            data.append(publicKey)
        }

        // Append the index
        data.append(contentsOf: withUnsafeBytes(of: index.bigEndian, Array.init))

        // Perform HMAC-SHA512
        guard data.count == 37 else {
            throw WalletError.failedToGenerateHmac
        }
        let hmac = Hmac.hmacSha512(key: parentKey.chainCode, data: data)

        // Convert L to an integer
        let L = BigInt(hmac.prefix(32).toHex(), radix: 16)!
        // Validate L
        guard L < Secp256k1CurveConstants.n else {
            throw WalletError.invalidChildKey
        }
        let R = hmac.suffix(32)  // Right 32 bytes (R)

        // Compute the child private key: (L + parentPrivateKey) % curveOrder
        let parentPrivateKeyInt = BigInt(parentKey.privateKey.toHex(), radix: 16)!
        let childPrivateKeyInt = (L + parentPrivateKeyInt) % Secp256k1CurveConstants.n

        // Ensure the child private key is valid
        guard childPrivateKeyInt != 0 else {
            throw WalletError.invalidChildKey
        }

        // Convert the child private key back to Data
        var childPrivateKey = childPrivateKeyInt.toData()
        guard childPrivateKey.count <= 32 else {
            throw WalletError.invalidChildKey
        }

        if childPrivateKey.count < 32 {
            // Pad with leading zeros to make it 32 bytes
            let padding = Data(repeating: 0, count: 32 - data.count)
            childPrivateKey = padding + data
        }

        // Return the new child key
        return Key(privateKey: childPrivateKey, chainCode: Data(R))
    }

    public func derivePath(path: String) throws -> any WalletInstance {
        let key = try Wallet.deriveKey(from: self._key, path: path)
        return try Wallet(key: key)
    }
}
