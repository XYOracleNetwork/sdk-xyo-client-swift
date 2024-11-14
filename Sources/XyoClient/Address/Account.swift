import Foundation

public class Account: AccountInstance, AccountStatic {
    let _account: XyoAddress
    var _previousHash: String? = nil

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

    public var previousHash: Hash? {
        return self._previousHash
    }

    public func sign(hash: Hash) throws -> String {
        guard let value = try self._account.sign(hash: hash) else {
            fatalError("Error signing hash")
        }
        _previousHash = value
        return value
    }
}
