import Foundation

struct XyoSystemInfoNetworkWiredPayloadStruct: Encodable {
    var ip: String?
    init() {
        ip = WifiInformation.pathMonitor.ip
    }
}
