import Foundation

public class AccountServices {
    func getNamedAccountOrRandom(name: String = "default") -> AccountInstance {
        var key: Data? = nil
        if let storedPrivateKeyString = getFromKeychain(name) {
            if let parsedPrivateKeyData = storedPrivateKeyString.data(using: .utf8) {
                key = parsedPrivateKeyData
            }

        }
        return Account.fromPrivateKey(key: key)
    }
}
