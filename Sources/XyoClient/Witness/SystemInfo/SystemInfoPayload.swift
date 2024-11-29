import Foundation

open class SystemInfoPayload: EncodablePayloadInstance {

    var wifiInfo: WifiInformation

    public init(_ wifiInfo: WifiInformation) {
        self.wifiInfo = wifiInfo
        super.init("network.xyo.system.info")
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
        try container.encode(SystemInfoDevicePayloadStruct(), forKey: .device)
        try container.encode(SystemInfoNetworkPayloadStruct(wifiInfo), forKey: .network)
        try container.encode(SystemInfoOsPayloadStruct(), forKey: .os)
        try container.encode(self.schema, forKey: .schema)
    }
}
