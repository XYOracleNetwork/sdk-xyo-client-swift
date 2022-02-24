import Foundation

open class XyoSystemInfoPayload: XyoPayload {
    
    var wifiInfo: WifiInformation
    
    public init(_ wifiInfo: WifiInformation, _ previousHash: String? = nil) {
        self.wifiInfo = wifiInfo
        super.init("network.xyo.system.info", previousHash)
    }
    
    enum CodingKeys: String, CodingKey {
        case device
        case network
        case os
        case previousHash
        case schema
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(XyoSystemInfoDevicePayloadStruct(), forKey: .device)
        try container.encode(XyoSystemInfoNetworkPayloadStruct(wifiInfo), forKey: .network)
        try container.encode(XyoSystemInfoOsPayloadStruct(), forKey: .os)
        try container.encode(self.previousHash, forKey: .previousHash)
        try container.encode(self.schema, forKey: .schema)
    }
}
