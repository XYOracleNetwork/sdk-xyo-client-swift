import Foundation

struct XyoSystemInfoNetworkWifiPayloadStruct: Encodable {
    var ssid: String?
    var mac: String?
    var rssi: Int?
    var txPower: Int?
    var security: String?
    var ip: String?
    init() {
        ssid = WifiInformation.ssid()
        mac = WifiInformation.mac()
        rssi = WifiInformation.rssi()
        txPower = WifiInformation.txPower()
        security = WifiInformation.security()
        ip = WifiInformation.pathMonitor.ip
    }
}
