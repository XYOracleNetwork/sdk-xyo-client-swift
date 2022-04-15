import Foundation
import secp256k1

public class XyoAddress {
    
    private var _privateKey: secp256k1.Signing.PrivateKey?
    
    public init(_ privateKey: Data? = generateRandomBytes()) {
        self._privateKey = try? secp256k1.Signing.PrivateKey(rawRepresentation: privateKey ?? generateRandomBytes(32), format: .uncompressed)
    }
    
    convenience init(privateKey: String) {
        self.init(privateKey.hexToData())
    }
    
    public var privateKey: secp256k1.Signing.PrivateKey? {
        get {
            return _privateKey
        }
    }
    
    public var privateKeyBytes: Data? {
        get {
            return _privateKey?.rawRepresentation
        }
    }
    
    public var privateKeyHex: String? {
        get {
            return privateKeyBytes?.toHex(64)
        }
    }
    
    public var publicKey: secp256k1.Signing.PublicKey? {
        get {
            return _privateKey?.publicKey
        }
    }
    
    public var publicKeyBytes: Data? {
        get {
            return _privateKey?.publicKey.rawRepresentation.subdata(in: 1..<(_privateKey?.publicKey.rawRepresentation.count ?? 0))
        }
    }
    
    public var publicKeyHex: String? {
        get {
            return publicKeyBytes?.toHex(128)
        }
    }
    
    public var keccakBytes: Data? {
        get {
            return publicKeyBytes?.keccak256()
        }
    }
    
    public var keccakHex: String? {
        get {
            guard let bytes = keccakBytes else { return nil }
                return bytes.toHex(64)
        }
    }
    
    public var addressBytes: Data? {
        get {
            guard let keccakBytes = keccakBytes else { return nil }
                return keccakBytes.subdata(in: 12..<keccakBytes.count)
        }
    }
    
    public var addressHex: String? {
        get {
            guard let bytes = addressBytes else { return nil }
                return bytes.toHex(40)
        }
    }
    
    public func sign(_ hash: String) throws -> String? {
        let message = hash.hexToData()
        guard (message != nil) else { return nil }
        let sig = self.signature(message!)
        return sig?.rawRepresentation.toHex()
    }
    
    public func signature(_ hash: Data) -> secp256k1.Signing.ECDSASignature? {
        do {
            let context = try secp256k1.Context.create()
            
            defer { secp256k1_context_destroy(context) }
            
            var signature = secp256k1_ecdsa_signature()
            
            let arrayHash = Array(hash)
            let privKey = Array(self._privateKey!.rawRepresentation)
            
            guard secp256k1_ecdsa_sign(context, &signature, arrayHash, privKey, nil, nil) == 1 else {
                throw secp256k1Error.underlyingCryptoError
            }
            
            var signature2 = secp256k1_ecdsa_signature()
            withUnsafeMutableBytes(of: &signature2) { signature2Bytes in
                withUnsafeBytes(of: &signature) { signatureBytes in
                    for i in 0...31 {
                        signature2Bytes[i] = signatureBytes[31 - i]
                        signature2Bytes[i+32] = signatureBytes[63 - i]
                    }
                }
            }
            
            let rawRepresentation = Data(bytes: &signature2.data, count: MemoryLayout.size(ofValue: signature2.data))
            
            return try secp256k1.Signing.ECDSASignature(rawRepresentation: rawRepresentation)
        } catch {
            return nil
        }
    }
}

public func generateRandomBytes(_ count: Int = 32) -> Data {

    var keyData = Data(count: count)
    let result = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
    }
    if result == errSecSuccess {
        return keyData
    } else {
        print("Problem generating random bytes")
        var simpleRandom = Data.init()
        var randomGenerator = SystemRandomNumberGenerator()
        while(simpleRandom.count < count) {
            simpleRandom.append(contentsOf: [UInt8(randomGenerator.next())])
        }
        return simpleRandom
    }
}
