import Foundation

public func generateRandomBytes(_ count: Int = 32) -> Data {

    var keyData = Data(count: count)
    let result = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
    }
    if result == errSecSuccess {
        return keyData
    } else {
        print("Problem generating random bytes")
        var simpleRandom = Data()
        var randomGenerator = SystemRandomNumberGenerator()
        while simpleRandom.count < count {
            simpleRandom.append(contentsOf: [UInt8(randomGenerator.next())])
        }
        return simpleRandom
    }
}
