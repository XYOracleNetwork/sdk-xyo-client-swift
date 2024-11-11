import Foundation

public protocol Witness {
  associatedtype TPayloadIn: XyoPayload
  associatedtype TPayloadOut: XyoPayload
  var address: XyoAddress? { get }
  var previousHash: String? { get }
  func observe(payloads: [TPayloadIn]?) -> [TPayloadOut]
}

open class XyoWitness<TIn: XyoPayload, TOut: XyoPayload>: Witness {
  public typealias TPayloadIn = TIn
  public typealias TPayloadOut = TOut

  public let address: XyoAddress?
  public var previousHash: String?

  public init(_ address: XyoAddress? = nil, previousHash: String? = nil) {
    self.address = address ?? XyoAddress()
    self.previousHash = previousHash
  }

  open func observe(payloads: [TPayloadIn]?) -> [TPayloadOut] {
    preconditionFailure("This method must be overridden")
  }
}
