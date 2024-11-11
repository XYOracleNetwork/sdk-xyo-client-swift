import Foundation

public protocol Witness {
  associatedtype TPayload: XyoPayload
  var address: XyoAddress? { get }
  var previousHash: String? { get }
  func observe() -> [TPayload]
}

open class XyoWitness: Witness {
  public let address: XyoAddress?
  public var previousHash: String?

  public init(_ address: XyoAddress? = nil, previousHash: String? = nil) {
    self.address = address ?? XyoAddress()
    self.previousHash = previousHash
  }

  open func observe() -> [XyoPayload] {
    preconditionFailure("This method must be overridden")
  }
}
