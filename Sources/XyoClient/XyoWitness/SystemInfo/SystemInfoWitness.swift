import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    var wifiInfo: WifiInformation?
    
    init() {}
    
    init(_ wifiInfo: WifiInformation?) {
        self.wifiInfo = wifiInfo
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        let payload = XyoSystemInfoPayload(wifiInfo, previousHash)
        previousHash = try? payload.hash()
        return payload
    }
}
