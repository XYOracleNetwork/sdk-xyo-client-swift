import Foundation

open class XyoSystemInfoPayload: XyoPayload {
    
    var wifiInfo: WifiInformation?
    
    public init(_ wifiInfo: WifiInformation? = nil, _ previousHash: String? = nil) {
        self.wifiInfo = wifiInfo
        super.init("network.xyo.system.info", previousHash)
    }
    
    enum CodingKeys: String, CodingKey {
        case device
        case network
        case os
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(XyoSystemInfoDevicePayloadStruct(), forKey: .device)
        if let wifiInfo = self.wifiInfo {
            try container.encode(XyoSystemInfoNetworkPayloadStruct(wifiInfo), forKey: .network)
        }
        try container.encode(XyoSystemInfoOsPayloadStruct(), forKey: .os)
    }
}
