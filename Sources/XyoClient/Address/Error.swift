import Foundation

enum XyoAddressError: Error {
    case invalidPrivateKey
    case invalidPrivateKeyLength
    case invalidHash
    case signingFailed
}
