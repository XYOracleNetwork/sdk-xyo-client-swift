import Foundation

public class Account: AccountInstance, AccountStatic {
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

    // Allow only internal updates via a specific method or internal setter
    internal func persistPreviousHash(newValue: Hash?) {
        if (previousHash != nil){
            // TODO: Persist to store
        }
    }
    

    public func sign(hash: Hash) throws -> String {
        guard let value = try self._account.sign(hash: hash) else {
            fatalError("Error signing hash")
        }
        previousHash = value
        return value
    }
}
