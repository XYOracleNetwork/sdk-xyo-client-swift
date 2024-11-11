open class AbstractModule: Module {
  public let address: XyoAddress
  public var previousHash: String?

  public init(address: XyoAddress? = nil, previousHash: String? = nil) {
    self.address = address ?? XyoAddress()
    self.previousHash = previousHash
  }
}
