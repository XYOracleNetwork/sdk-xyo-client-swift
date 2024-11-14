import Foundation

struct SystemInfoNetworkWifiPayloadStruct: Encodable {
    var ip: String?
    var mac: String?
    var rssi: Int?
    var security: String?
    var ssid: String?
    var txPower: Int?
    init(_ wifiInfo: WifiInformation?) {
        ssid = wifiInfo?.ssid()
        mac = wifiInfo?.mac()
        rssi = wifiInfo?.rssi()
        txPower = wifiInfo?.txPower()
        security = wifiInfo?.security()
        ip = wifiInfo?.pathMonitor?.ip
    }
}
