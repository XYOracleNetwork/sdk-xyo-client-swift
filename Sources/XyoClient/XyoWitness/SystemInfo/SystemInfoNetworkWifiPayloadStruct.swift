import Foundation

struct XyoSystemInfoNetworkWifiPayloadStruct: Encodable {
    var ip: String?
    var mac: String?
    var rssi: Int?
    var security: String?
    var ssid: String?
    var txPower: Int?
    init() {
        ssid = WifiInformation.ssid()
        mac = WifiInformation.mac()
        rssi = WifiInformation.rssi()
        txPower = WifiInformation.txPower()
        security = WifiInformation.security()
        ip = WifiInformation.pathMonitor.ip
    }
}
