import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    var wifiInfo: WifiInformation?
    
    init(_ wifiInfo: WifiInformation? = nil) {
        self.wifiInfo = wifiInfo
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        let payload = XyoSystemInfoPayload(wifiInfo, previousHash)
        previousHash = try? payload.hash()
        return payload
    }
}
