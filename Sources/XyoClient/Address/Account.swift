import Foundation
import secp256k1

public func dataFromHex(_ hex: String) -> Data? {
    let hex = hex.replacingOccurrences(of: " ", with: "") // Remove any spaces
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

public extension Data {
    init?(_ hex: String) {
        let hex = hex.replacingOccurrences(of: " ", with: "") // Remove any spaces
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
    case invalidPrivateKey
    case invalidMessage
}

public class Account: AccountInstance, AccountStatic {
    public let privateKey: Data?
    
    private var _previousHash: Hash?
    
    public var publicKey: Data? {
        guard let privateKey = self.privateKey else {return nil}
        return try? Account.privateKeyObjectFromKey(privateKey).publicKey.dataRepresentation
    }
    
    public static func fromPrivateKey(_ key: String) throws -> AccountInstance {
        guard let data = Data(key) else { throw AccountError.invalidPrivateKey }
        return Account(data)
    }
    
    public func sign(hash: String) throws -> Signature {
        guard let message = hash.hexToData() else { throw AccountError.invalidMessage }
        return try self.sign(message)
    }

    public func sign(_ hash: Hash) throws -> Signature {
        let context = try secp256k1.Context.create()
        guard let privateKey = self.privateKey else {throw AccountError.invalidPrivateKey}

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

        return try secp256k1.Signing.ECDSASignature(dataRepresentation: rawRepresentation).dataRepresentation
    }
    
    public func verify(_ msg: Data, _ signature: Signature) -> Bool {
        return false
    }
    
    public var keccakBytes: Data? {
        return publicKey?.keccak256()
    }
    
    public var address: Data? {
        guard let keccakBytes = keccakBytes else {return nil}
        return keccakBytes.subdata(in: 12..<keccakBytes.count)
    }
    
    public static var previousHashStore: PreviousHashStore? = CoreDataPreviousHashStore()

    public static func fromPrivateKey(_ key: Data) -> any AccountInstance {
        return Account(key)
    }

    public static func random() -> AccountInstance {
        return Account(generateRandomBytes())
    }

    init(_ privateKey: Data, _ previousHash: Hash? = nil) {
        self.privateKey = privateKey
        self._previousHash = previousHash
    }

    public internal(set) var previousHash: Hash? = nil {
        willSet {
            // Store to previous hash store
            try? persistPreviousHash(newValue: newValue)
        }
    }
    
    public static func privateKeyObjectFromKey(_ key: Data) throws -> secp256k1.Signing.PrivateKey {
        return try secp256k1.Signing.PrivateKey(
            dataRepresentation: key, format: .uncompressed)
    }

    internal func persistPreviousHash(newValue: Hash?) throws {
        guard let address = self.address else { throw AccountError.invalidAddress }
        if let previousHash = newValue {
            Account.previousHashStore?.setItem(address: address, previousHash: previousHash)
        }
    }
}
