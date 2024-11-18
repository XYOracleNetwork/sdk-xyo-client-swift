import Foundation

public class AccountServices {
    public static func getNamedAccount(name: String = "default") -> AccountInstance {
        //        let _ = removeFromKeychain(key: name)
        if let existingAccount = getStoredAccount(name: name) {
            return existingAccount
        } else {
            let address = XyoAddress()
            if let privateKey = address.privateKeyHex {
                if !saveToKeychain(key: name, value: privateKey) {
                    // TODO: Avoiding throw here but better handling of this
                    // case would be desirable
                    return Account()
                }
            }
            return Account(address: address)
        }
    }

    private static func getStoredAccount(name: String) -> AccountInstance? {
        // Lookup previously saved private key if it exists
        if let storedPrivateKeyString = getFromKeychain(key: name) {
            if let parsedPrivateKeyData = Data.dataFrom(hexString: storedPrivateKeyString) {
                return Account.fromPrivateKey(key: parsedPrivateKeyData)
            }
        }
        // Otherwise, return nil
        return nil
    }

}
