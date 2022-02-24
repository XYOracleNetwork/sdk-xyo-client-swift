import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    var wifiInfo: WifiInformation
    
    public init(_ allowPathMonitor: Bool = false) {
        self.wifiInfo = WifiInformation(allowPathMonitor)
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        let payload = XyoSystemInfoPayload(wifiInfo, previousHash)
        previousHash = try? payload.hash().toHex()
        return payload
    }
}
