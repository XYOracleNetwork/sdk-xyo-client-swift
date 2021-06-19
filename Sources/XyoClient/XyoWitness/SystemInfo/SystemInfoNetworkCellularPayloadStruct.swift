import Foundation
import CoreTelephony

struct XyoSystemInfoNetworkCellularPayloadStruct: Encodable {
    var provider = XyoSystemInfoCellularProviderPayloadStruct()
    var radio: String?
    var ip: String?
    init() {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        radio = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value
        #endif
        ip = WifiInformation.pathMonitor.ip
    }
}
