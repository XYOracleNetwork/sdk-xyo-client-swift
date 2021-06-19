import Foundation
import CoreTelephony

struct XyoSystemInfoCellularProviderPayloadStruct: Encodable {
    var name: String?
    var mcc: String?
    var mnc: String?
    var icc: String?
    var allowVoip: Bool?
    init() {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        let subscriberCellularProvider = networkInfo.serviceSubscriberCellularProviders?.first?.value
        name = subscriberCellularProvider?.carrierName
        mcc = subscriberCellularProvider?.mobileCountryCode
        mnc = subscriberCellularProvider?.mobileNetworkCode
        icc = subscriberCellularProvider?.isoCountryCode
        allowVoip = subscriberCellularProvider?.allowsVOIP
        #endif
    }
}
