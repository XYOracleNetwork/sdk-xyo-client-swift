import Foundation

open class XyoBasicWitness: AbstractWitness {

  public typealias TPayloadOut = XyoPayload

  public init(observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(address: XyoAddress, observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(address: address)
  }

  public typealias ObserverClosure = (() -> XyoPayload?)

  private let _observer: ObserverClosure

  override public func observe() -> [XyoPayload] {
    if let payload = _observer() {
      return [payload]
    } else {
      return []
    }
  }
}
