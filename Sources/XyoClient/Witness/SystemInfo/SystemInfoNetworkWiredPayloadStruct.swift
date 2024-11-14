import Foundation

struct XyoSystemInfoNetworkWiredPayloadStruct: Encodable {
    var ip: String?
    init(_ wifiInfo: WifiInformation?) {
        ip = wifiInfo?.pathMonitor?.ip
    }
}
