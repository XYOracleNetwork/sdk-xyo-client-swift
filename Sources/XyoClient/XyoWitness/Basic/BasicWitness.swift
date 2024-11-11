import Foundation

open class XyoBasicWitness: XyoWitness<XyoPayload, XyoPayload> {

  public init(_ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(address)
  }

  public typealias ObserverClosure = ((_ previousHash: String?) -> XyoPayload?)

  private let _observer: ObserverClosure

  override public func observe(payloads: [XyoPayload]?) -> [XyoPayload] {
    if let payload = _observer(previousHash) {
      previousHash = try? payload.hash().toHex()
      return [payload]
    } else {
      return []
    }
  }
}
