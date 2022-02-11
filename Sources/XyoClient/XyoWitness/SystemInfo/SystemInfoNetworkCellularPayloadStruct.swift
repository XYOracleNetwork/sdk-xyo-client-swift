import Foundation
import CoreTelephony

struct XyoSystemInfoNetworkCellularPayloadStruct: Encodable {
    var ip: String?
    var provider = XyoSystemInfoCellularProviderPayloadStruct()
    var radio: String?
    init(_ wifiInfo: WifiInformation?) {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        radio = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value
        #endif
        ip = wifiInfo?.pathMonitor?.ip
    }
}
