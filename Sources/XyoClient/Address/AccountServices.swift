import Foundation

public class AccountServices {
    func getNamedAccountOrRandom(name: String = "default") -> AccountInstance {
        // Returns stored private key or nil (if none previusly stored)
        // which results in creation of a random account
        var key = getStoredPrivateKey(name: name)

        // Create account from stored key or nil (random)
        return Account.fromPrivateKey(key: key)
    }
    func initializeNamedAccountOrRandom(name: String = "default") -> AccountInstance {
        var key: Data? = nil
        if let storedPrivateKeyString = getFromKeychain(key: name) {
            if let parsedPrivateKeyData = storedPrivateKeyString.data(using: .utf8) {
                key = parsedPrivateKeyData
                return Account.fromPrivateKey(key: key)
            }

        }
        let address = XyoAddress()
        if let privateKey = address.privateKeyHex {
            if !saveToKeychain(key: name, value: privateKey ) {
                // TODO: Log
            }
        }
        return Account(address: address)
    }
    
    private func getStoredPrivateKey(name: String) -> Data? {
        // Lookup previously saved private key if it exists
        if let storedPrivateKeyString = getFromKeychain(key: name) {
            if let parsedPrivateKeyData = storedPrivateKeyString.data(using: .utf8) {
                return parsedPrivateKeyData
            }
        }
        // Otherwise, return nil
        return nil
    }
}
