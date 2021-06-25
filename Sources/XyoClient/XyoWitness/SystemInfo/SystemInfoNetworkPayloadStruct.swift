import Foundation

struct XyoSystemInfoNetworkPayloadStruct: Encodable {
    var cellular = WifiInformation.isCellular() ? XyoSystemInfoNetworkCellularPayloadStruct() : nil
    var wifi = WifiInformation.isWifi() ? XyoSystemInfoNetworkWifiPayloadStruct() : nil
    var wired = WifiInformation.isWired() ? XyoSystemInfoNetworkWiredPayloadStruct() : nil
}
