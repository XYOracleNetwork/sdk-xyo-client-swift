open class AbstractModule: Module {

  public let address: XyoAddress
  public var previousHash: String? {
    address.previousHash
  }

  public init(address: XyoAddress? = nil) {
    self.address = address ?? XyoAddress()
  }
}
