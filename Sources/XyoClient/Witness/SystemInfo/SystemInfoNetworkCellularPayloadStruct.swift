import CoreTelephony
import Foundation

struct SystemInfoNetworkCellularPayloadStruct: Encodable {
    var ip: String?
    var provider = SystemInfoCellularProviderPayloadStruct()
    var radio: String?
    init(_ wifiInfo: WifiInformation?) {
        #if os(iOS)
            let networkInfo = CTTelephonyNetworkInfo()
            radio = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value
        #endif
        ip = wifiInfo?.pathMonitor?.ip
    }
}
