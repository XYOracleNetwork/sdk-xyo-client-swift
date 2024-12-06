import BigInt
import Foundation
import secp256k1

public func dataFromHex(_ hex: String) -> Data? {
    let hex = hex.replacingOccurrences(of: " ", with: "")  // Remove any spaces
    let len = hex.count

    // Ensure even length (hex must be in pairs)
    guard len % 2 == 0 else { return nil }

    var data = Data(capacity: len / 2)

    var index = hex.startIndex
    for _ in 0..<(len / 2) {
        let nextIndex = hex.index(index, offsetBy: 2)
        guard let byte = UInt8(hex[index..<nextIndex], radix: 16) else { return nil }
        data.append(byte)
        index = nextIndex
    }

    return data
}

extension Data {
    public init?(_ hex: String) {
        let hex = hex.replacingOccurrences(of: " ", with: "")  // Remove any spaces
        let len = hex.count

        // Ensure even length (hex must be in pairs)
        guard len % 2 == 0 else { return nil }

        var data = Data(capacity: len / 2)

        var index = hex.startIndex
        for _ in 0..<(len / 2) {
            let nextIndex = hex.index(index, offsetBy: 2)
            guard let byte = UInt8(hex[index..<nextIndex], radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }

        guard let result = dataFromHex(hex) else { return nil }

        self = result
    }
}

enum AccountError: Error {
    case invalidAddress
    case invalidMessage
    case invalidPrivateKey
}

public class Account: AccountInstance, AccountStatic {

    public static var previousHashStore: PreviousHashStore = CoreDataPreviousHashStore()

    private var _privateKey: Data?

    public var address: Data? {
        // Get the keccak hash of the public key
        guard let keccakBytes = keccakBytes else { return nil }
        // Return the last 20 bytes of the keccak hash
        return keccakBytes.suffix(20)
    }

    public var keccakBytes: Data? {
        return publicKeyUncompressed?
            // Drop the `0x04` from the beginning of the key
            .dropFirst()
            // Then take the keccak256 hash of the key
            .keccak256()
    }

    public var previousHash: Hash? {
        return try? retrievePreviousHash()
    }

    public var privateKey: Data? {
        return _privateKey
    }

    public var publicKey: Data? {
        guard
            let publicKeyUncompressed = publicKeyUncompressed?
                // Drop the `0x04` from the beginning of the key
                .dropFirst()
        else { return nil }
        return try? Account.getCompressedPublicKeyFrom(uncompressedPublicKey: publicKeyUncompressed)
    }

    public var publicKeyUncompressed: Data? {
        guard let privateKey = self.privateKey else { return nil }
        return try? Account.privateKeyObjectFromKey(privateKey).publicKey.dataRepresentation
    }

    public static func fromPrivateKey(_ key: Data) -> any AccountInstance {
        return Account(key)
    }

    public static func fromPrivateKey(_ key: String) throws -> AccountInstance {
        guard let data = Data(key) else { throw AccountError.invalidPrivateKey }
        return Account(data)
    }

    public static func random() -> AccountInstance {
        return Account(generateRandomBytes())
    }

    init(_ privateKey: Data) {
        self._privateKey = privateKey
    }

    public func sign(_ hash: Hash) throws -> Signature {
        let context = try secp256k1.Context.create()
        guard let privateKey = self.privateKey else { throw AccountError.invalidPrivateKey }

        defer { secp256k1_context_destroy(context) }

        var signature = secp256k1_ecdsa_signature()

        let arrayHash = Array(hash)
        let privateKeyArray = Array(privateKey)

        guard secp256k1_ecdsa_sign(context, &signature, arrayHash, privateKeyArray, nil, nil) == 1
        else {
            throw secp256k1Error.underlyingCryptoError
        }

        var signature2 = secp256k1_ecdsa_signature()
        withUnsafeMutableBytes(of: &signature2) { signature2Bytes in
            withUnsafeBytes(of: &signature) { signatureBytes in
                for i in 0...31 {
                    signature2Bytes[i] = signatureBytes[31 - i]
                    signature2Bytes[i + 32] = signatureBytes[63 - i]
                }
            }
        }

        let rawRepresentation = Data(
            bytes: &signature2.data,
            count: MemoryLayout.size(ofValue: signature2.data)
        )

        let result = try secp256k1.Signing.ECDSASignature(dataRepresentation: rawRepresentation)
            .dataRepresentation
        try self.storePreviousHash(hash)
        return result
    }

    public func sign(hash: String) throws -> Signature {
        guard let message = hash.hexToData() else { throw AccountError.invalidMessage }
        return try self.sign(message)
    }

    public func verify(_ msg: Data, _ signature: Signature) -> Bool {
        return false
    }

    internal func retrievePreviousHash() throws -> Hash? {
        guard let address = self.address else { throw AccountError.invalidAddress }
        return Account.previousHashStore.getItem(address: address)
    }

    internal func storePreviousHash(_ newValue: Hash?) throws {
        guard let address = self.address else { throw AccountError.invalidAddress }
        if let previousHash = newValue {
            Account.previousHashStore.setItem(address: address, previousHash: previousHash)
        }
    }

    public static func getCompressedPublicKeyFrom(privateKey: Data) throws -> Data {
        guard
            let uncompressedPublicKey = XyoAddress(privateKey: privateKey.toHexString())
                .publicKeyBytes
        else {
            throw WalletError.failedToGetPublicKey
        }
        return try Account.getCompressedPublicKeyFrom(uncompressedPublicKey: uncompressedPublicKey)
    }

    public static func getCompressedPublicKeyFrom(uncompressedPublicKey: Data) throws -> Data {
        // Ensure the input key is exactly 64 bytes
        guard uncompressedPublicKey.count == 64 else {
            throw AccountError.invalidPrivateKey
        }

        // Extract x and y coordinates
        let x = uncompressedPublicKey.prefix(32)  // First 32 bytes are x
        let y = uncompressedPublicKey.suffix(32)  // Last 32 bytes are y

        // Convert y to an integer to determine parity
        let yInt = BigInt(y.toHex(), radix: 16)!
        let isEven = yInt % 2 == 0

        // Determine the prefix based on the parity of y
        let prefix: UInt8 = isEven ? 0x02 : 0x03

        // Construct the compressed key: prefix + x
        var compressedKey = Data([prefix])  // Start with the prefix
        compressedKey.append(x)  // Append the x-coordinate

        return compressedKey
    }

    public static func privateKeyObjectFromKey(_ key: Data) throws -> secp256k1.Signing.PrivateKey {
        return try secp256k1.Signing.PrivateKey(
            dataRepresentation: key, format: .uncompressed)
    }
}
