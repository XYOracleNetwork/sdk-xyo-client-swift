import Foundation
import secp256k1

public class XyoAddress {

    private var _privateKey: secp256k1.Signing.PrivateKey?

    public init(_ privateKey: Data? = generateRandomBytes()) {
        self._privateKey = try? secp256k1.Signing.PrivateKey(
            dataRepresentation: privateKey ?? generateRandomBytes(32), format: .uncompressed)
    }

    convenience init(privateKey: String) {
        self.init(privateKey.hexToData())
    }

    public var privateKey: secp256k1.Signing.PrivateKey? {
        return _privateKey
    }

    public var privateKeyBytes: Data? {
        return _privateKey?.dataRepresentation
    }

    public var privateKeyHex: String? {
        return privateKeyBytes?.toHex(64)
    }

    public var publicKey: secp256k1.Signing.PublicKey? {
        return _privateKey?.publicKey
    }

    public var publicKeyBytes: Data? {
        return _privateKey?.publicKey.dataRepresentation.subdata(
            in: 1..<(_privateKey?.publicKey.dataRepresentation.count ?? 0))
    }

    public var publicKeyHex: String? {
        return publicKeyBytes?.toHex(128)
    }

    public var keccakBytes: Data? {
        return publicKeyBytes?.keccak256()
    }

    public var keccakHex: String? {
        guard let bytes = keccakBytes else { return nil }
        return bytes.toHex(64)
    }

    public var address: String? {
        return self.addressHex
    }

    public var addressBytes: Data? {
        guard let keccakBytes = keccakBytes else { return nil }
        return keccakBytes.subdata(in: 12..<keccakBytes.count)
    }

    public var addressHex: String? {
        guard let bytes = addressBytes else { return nil }
        return bytes.toHex(40)
    }

    public func sign(hash: String) throws -> String? {
        let message = hash.hexToData()
        guard message != nil else { return nil }
        let sig = self.signature(message!)
        return sig?.dataRepresentation.toHex()
    }

    public func signature(_ hash: Data) -> secp256k1.Signing.ECDSASignature? {
        do {
            let context = try secp256k1.Context.create()

            defer { secp256k1_context_destroy(context) }

            var signature = secp256k1_ecdsa_signature()

            let arrayHash = Array(hash)
            let privKey = Array(self._privateKey!.dataRepresentation)

            guard secp256k1_ecdsa_sign(context, &signature, arrayHash, privKey, nil, nil) == 1
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

            return try secp256k1.Signing.ECDSASignature(dataRepresentation: rawRepresentation)
        } catch {
            return nil
        }
    }
}
