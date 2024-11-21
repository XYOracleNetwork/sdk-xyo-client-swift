import Foundation

public class Account: AccountInstance, AccountStatic {
    public static var previousHashStore: PreviousHashStore = CoreDataPreviousHashStore()

    let _account: XyoAddress

    public static func fromPrivateKey(key: Data?) -> AccountInstance {
        guard let key else {
            return Account()
        }
        let address = XyoAddress(key)
        return Account(address: address)
    }

    public static func random() -> AccountInstance {
        return Account()
    }

    init() {
        self._account = XyoAddress()
    }

    init(address: XyoAddress) {
        self._account = address
        if let addressString = address.address {
            self.previousHash = Account.previousHashStore.getItem(address: addressString)
        }
    }

    public var address: Address {
        guard let value = self._account.address else {
            fatalError("Invalid address")
        }
        return value as Address
    }

    public var addressBytes: Data {
        guard let value = self._account.addressBytes else {
            fatalError("Invalid addressBytes")
        }
        return value
    }

    public internal(set) var previousHash: Hash? = nil {
        willSet {
            // Store to previous hash store
            persistPreviousHash(newValue: newValue)
        }
    }

    internal func persistPreviousHash(newValue: Hash?) {
        if let previousHash = newValue {
            Account.previousHashStore.setItem(address: self.address, previousHash: previousHash)
        }
    }

    public func sign(hash: Hash) throws -> String {
        guard let value = try self._account.sign(hash: hash) else {
            fatalError("Error signing hash")
        }
        previousHash = hash
        return value
    }
}
