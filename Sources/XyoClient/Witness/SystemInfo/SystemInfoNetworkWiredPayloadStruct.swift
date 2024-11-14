import Foundation

struct SystemInfoNetworkWiredPayloadStruct: Encodable {
    var ip: String?
    init(_ wifiInfo: WifiInformation?) {
        ip = wifiInfo?.pathMonitor?.ip
    }
}
