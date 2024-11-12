open class AbstractModule: Module {

  private let _account: XyoAddress

  public var account: AccountInstance {
    _account
  }

  public var address: String? {
    _account.addressHex
  }

  public var previousHash: String? {
    _account.previousHash
  }

  public init(account: XyoAddress? = nil) {
    self._account = account ?? XyoAddress()
  }
}
