import Foundation

struct XyoSystemInfoNetworkPayloadStruct: Encodable {
    var wifi = WifiInformation.isWifi() ? XyoSystemInfoNetworkWifiPayloadStruct() : nil
    var cellular = WifiInformation.isCellular() ? XyoSystemInfoNetworkCellularPayloadStruct() : nil
    var wired = WifiInformation.isWired() ? XyoSystemInfoNetworkWiredPayloadStruct() : nil
}
