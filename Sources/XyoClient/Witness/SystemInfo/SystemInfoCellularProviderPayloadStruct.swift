import CoreTelephony
import Foundation

struct SystemInfoCellularProviderPayloadStruct: Encodable {
    var allowVoip: Bool?
    var icc: String?
    var name: String?
    var mcc: String?
    var mnc: String?
    init() {
        #if os(iOS)
            let networkInfo = CTTelephonyNetworkInfo()
            let subscriberCellularProvider = networkInfo.serviceSubscriberCellularProviders?.first?
                .value
            name = subscriberCellularProvider?.carrierName
            mcc = subscriberCellularProvider?.mobileCountryCode
            mnc = subscriberCellularProvider?.mobileNetworkCode
            icc = subscriberCellularProvider?.isoCountryCode
            allowVoip = subscriberCellularProvider?.allowsVOIP
        #endif
    }
}
