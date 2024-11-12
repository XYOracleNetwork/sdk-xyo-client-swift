import Foundation

open class XyoEventWitness: AbstractWitness {

  public init(_ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(account: address)
  }

  public typealias ObserverClosure = (() -> XyoEventPayload?)

  private let _observer: ObserverClosure

  public override func observe() -> [XyoPayload] {
    if let payload = _observer() {
      return [payload]
    } else {
      return []
    }
  }
}
