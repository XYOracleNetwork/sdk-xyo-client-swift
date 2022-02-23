import Foundation
import secp256k1

public class XyoAddress {
    
    private var _privateKey: secp256k1.Signing.PrivateKey?
    
    public init(_ privateKey: Data? = generateRandomBytes()) {
        self._privateKey = try? secp256k1.Signing.PrivateKey(rawRepresentation: privateKey ?? generateRandomBytes(32), format: .uncompressed)
        let pk = self._privateKey?.rawRepresentation
        let pk2 = self._privateKey?.rawRepresentation
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
            return privateKeyBytes?.toHex()
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
            return publicKeyBytes?.toHex()
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
                return bytes.toHex()
        }
    }
    
    public func sign(_ hash: String) throws -> Data? {
        let message = hash.hexToData()
        guard (message != nil) else { return nil }
        return try? _privateKey?.signature(for: message!).rawRepresentation
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
