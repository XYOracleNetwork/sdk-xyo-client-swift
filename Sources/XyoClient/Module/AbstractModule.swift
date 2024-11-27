open class AbstractModule: Module {

    private let _account: AccountInstance

    public var account: AccountInstance {
        _account
    }

    public var address: Address? {
        _account.address
    }

    public var previousHash: Hash? {
        _account.previousHash
    }

    public init(account: AccountInstance? = nil) {
        self._account = account ?? Account.random()
    }
}
