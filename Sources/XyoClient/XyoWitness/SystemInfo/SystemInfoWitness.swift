import Foundation

open class XyoSystemInfoWitness: XyoWitness {

  public typealias TPayloadIn = XyoPayload
  public typealias TPayloadOut = XyoSystemInfoPayload

  var wifiInfo: WifiInformation

  public init(_ allowPathMonitor: Bool = false) {
    self.wifiInfo = WifiInformation(allowPathMonitor)
  }

  public typealias ObserverClosure = ((_ previousHash: String?) -> XyoSystemInfoPayload?)

  public func observe(_: [XyoPayload]?) -> [XyoSystemInfoPayload] {
    let payload = XyoSystemInfoPayload(wifiInfo)
    previousHash = try? payload.hash().toHex()
    return [payload]
  }
}
