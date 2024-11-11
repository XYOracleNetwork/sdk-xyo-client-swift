import Foundation

open class XyoBasicWitness: XyoWitness {

  public typealias TPayloadOut = XyoPayload

  public init(observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(address: XyoAddress, observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(address: address)
  }

  public typealias ObserverClosure = ((_ previousHash: String?) -> XyoPayload?)

  private let _observer: ObserverClosure

  override public func observe() -> [XyoPayload] {
    if let payload = _observer(previousHash) {
      previousHash = try? payload.hash().toHex()
      return [payload]
    } else {
      return []
    }
  }
}
