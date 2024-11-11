import Foundation

open class XyoWitness: Module, Witness {
  public typealias TPayloadOut = XyoPayload

  public let address: XyoAddress
  public var previousHash: String?

  public init(address: XyoAddress? = nil, previousHash: String? = nil) {
    self.address = address ?? XyoAddress()
    self.previousHash = previousHash
  }

  open func observe() -> [TPayloadOut] {
    preconditionFailure("This method must be overridden")
  }
}
