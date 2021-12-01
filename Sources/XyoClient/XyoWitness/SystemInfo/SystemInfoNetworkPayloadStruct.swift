import Foundation

struct XyoSystemInfoNetworkPayloadStruct: Encodable {
    var cellular: XyoSystemInfoNetworkCellularPayloadStruct?
    var wifi: XyoSystemInfoNetworkWifiPayloadStruct?
    var wired: XyoSystemInfoNetworkWiredPayloadStruct?
    
    init(_ wifiInfo: WifiInformation) {
        cellular = wifiInfo.isCellular() ? XyoSystemInfoNetworkCellularPayloadStruct(wifiInfo) : nil
        wifi = wifiInfo.isWifi() ? XyoSystemInfoNetworkWifiPayloadStruct(wifiInfo) : nil
        wired = wifiInfo.isWired() ? XyoSystemInfoNetworkWiredPayloadStruct(wifiInfo) : nil
    }
}
