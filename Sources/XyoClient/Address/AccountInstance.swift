import Foundation

public typealias Signature = Data

public protocol PublicKeyInstance {
    var address: Address? { get }
    func verify(_ msg: Data, _ signature: Signature) -> Bool
}

public protocol PrivateKeyInstance: PublicKeyInstance {
    func sign(_ hash: Hash) throws -> Signature
}

public protocol AccountInstance: PrivateKeyInstance {
    var previousHash: Hash? { get }
    var privateKey: Data? { get }
    var publicKey: Data? { get }
    var publicKeyUncompressed: Data? { get }

}
