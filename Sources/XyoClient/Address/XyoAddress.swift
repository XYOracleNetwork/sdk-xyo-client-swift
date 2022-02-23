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
            return _privateKey?.publicKey.rawRepresentation
        }
    }
    
    public var publicKeyHex: String? {
        get {
            var bytes = publicKeyBytes ?? Data()
            if (bytes.count != 0) {
                let _ = bytes.popFirst()
                return bytes.toHex()
            }
            return nil
        }
    }
    
    public var addressBytes: Data? {
        get {
            return _privateKey?.publicKey.rawRepresentation
        }
    }
    
    public var addressHex: String? {
        get {
            var bytes = addressBytes ?? Data()
            if (bytes.count != 0) {
                let _ = bytes.popFirst()
                return bytes.toHex()
            }
            return nil
        }
    }
    
    public func sign(_ hash: String) throws -> Data? {
        let message = hash.hexToData()
        guard (message != nil) else { return nil }
        return try? _privateKey?.signature(for: message!).rawRepresentation
    }
}

extension String {
    func hexToData() -> Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else {
            return nil
        }

        return data
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
