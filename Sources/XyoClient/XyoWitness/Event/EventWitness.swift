import Foundation

open class XyoEventWitness: XyoWitness {

  public init(_ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(address: address)
  }

  public typealias ObserverClosure = (() -> XyoEventPayload?)

  private let _observer: ObserverClosure

  public override func observe() -> [XyoPayload] {
    if let payload = _observer() {
      previousHash = try? payload.hash().toHex()
      return [payload]
    } else {
      return []
    }
  }
}
