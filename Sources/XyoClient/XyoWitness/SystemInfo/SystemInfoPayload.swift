import Foundation

open class XyoSystemInfoPayload: XyoPayload {
    init() {
        super.init("network.xyo.system.info")
    }
    
    enum CodingKeys: String, CodingKey {
        case os
        case network
        case device
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(XyoSystemInfoOsPayloadStruct(), forKey: .os)
        try container.encode(XyoSystemInfoNetworkPayloadStruct(), forKey: .network)
        try container.encode(XyoSystemInfoDevicePayloadStruct(), forKey: .device)
    }
}
