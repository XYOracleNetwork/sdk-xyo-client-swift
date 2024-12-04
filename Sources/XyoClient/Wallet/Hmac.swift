import CryptoKit
import Foundation

struct Hmac {
    static func hmacSha512(key: Data, data: Data) -> Data {
        let symmetricKey = SymmetricKey(data: key)
        let hmac = HMAC<SHA512>.authenticationCode(for: data, using: symmetricKey)
        return Data(hmac)  // Convert the result to Data
    }
}
