import Foundation

struct SystemInfoNetworkPayloadStruct: Encodable {
    var cellular: SystemInfoNetworkCellularPayloadStruct?
    var wifi: SystemInfoNetworkWifiPayloadStruct?
    var wired: SystemInfoNetworkWiredPayloadStruct?

    init(_ wifiInfo: WifiInformation) {
        cellular = wifiInfo.isCellular() ? SystemInfoNetworkCellularPayloadStruct(wifiInfo) : nil
        wifi = wifiInfo.isWifi() ? SystemInfoNetworkWifiPayloadStruct(wifiInfo) : nil
        wired = wifiInfo.isWired() ? SystemInfoNetworkWiredPayloadStruct(wifiInfo) : nil
    }
}
