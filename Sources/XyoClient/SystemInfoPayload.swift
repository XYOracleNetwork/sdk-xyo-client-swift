import Foundation
import Reachability
import CoreTelephony

#if os(iOS)
import SystemConfiguration.CaptiveNetwork
#endif

#if os(macOS)
import CoreWLAN
#endif

class SystemInformation {
    static func osName() -> String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #else
        return "unknown"
        #endif
    }
}

class WifiInformation {
    
    static let reachability = try! Reachability()
    #if os(iOS)
    static func ssid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    #elseif os(macOS)
    static func ssid() -> String? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        return interface?.ssid()
    }
    #else
    static func ssid() -> String? {
        return nil
    }
    #endif
    
    #if os(macOS)
    static func mac() -> String? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        return interface?.hardwareAddress()
    }
    #else
    static func mac() -> String? {
        return nil
    }
    #endif
    
    #if os(macOS)
    static func security() -> String? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        guard let security = interface?.security() else {return nil}
        switch(security) {
        case .WEP:
            return "wep"
        case .dynamicWEP:
            return "dynamicWEP"
        case .enterprise:
            return "enterprise"
        case .none:
            return "none"
        case .personal:
            return "personal"
        case .unknown:
            return "unknown"
        case .wpa2Enterprise:
            return "wpa2Enterprise"
        case .wpa2Personal:
            return "wpa2Personal"
        case .wpa3Enterprise:
            return "wpa3Enterprise"
        case .wpa3Personal:
            return "wpa3Personal"
        case .wpa3Transition:
            return "wpa3Transition"
        case .wpaEnterprise:
            return "wpaEnterprise"
        case .wpaEnterpriseMixed:
            return "wpaEnterpriseMixed"
        case .wpaPersonal:
            return "wpaPersonal"
        case .wpaPersonalMixed:
            return "wpaPersonalMixed"
        default:
            return nil
        }
    }
    #else
    static func security() -> String? {
        return nil
    }
    #endif
    
    #if os(macOS)
    static func isWifi() -> Bool {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        let security = interface?.security() ?? .none
        return security != .unknown
    }
    #else
    static func isWifi() -> Bool {
        return WifiInformation.reachability.connection == .wifi
    }
    #endif
    
    #if os(macOS)
    static func isEthernet() -> Bool {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        let security = interface?.security() ?? .none
        return security == .unknown
    }
    #else
    static func isEthernet() -> Bool {
        return false
    }
    #endif
    
    #if os(macOS)
    static func on() -> Bool? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        return interface?.powerOn()
    }
    #else
    static func on() -> Bool? {
        return nil
    }
    #endif
    
    #if os(macOS)
    static func rssi() -> Int? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        return interface?.rssiValue()
    }
    #else
    static func rssi() -> Int? {
        return nil
    }
    #endif
    
    #if os(macOS)
    static func txPower() -> Int? {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        return interface?.transmitPower()
    }
    #else
    static func txPower() -> Int? {
        return nil
    }
    #endif
}

struct XyoSystemInfoPayloadVersionStruct: Encodable {
    var major: Int
    var minor: Int
    var patch: Int
    init() {
        let osVersion = ProcessInfo().operatingSystemVersion
        major = osVersion.majorVersion
        minor = osVersion.minorVersion
        patch = osVersion.patchVersion
    }
}

struct XyoSystemInfoPayloadOsStruct: Encodable {
    var version = XyoSystemInfoPayloadVersionStruct()
    var name: String
    init() {
        name = SystemInformation.osName()
    }
}

struct XyoSystemInfoPayloadWifiStruct: Encodable {
    var ssid: String?
    var mac: String?
    var on: Bool?
    var rssi: Int?
    var txPower: Int?
    var security: String?
    init() {
        ssid = WifiInformation.ssid()
        mac = WifiInformation.mac()
        on = WifiInformation.on()
        rssi = WifiInformation.rssi()
        txPower = WifiInformation.txPower()
        security = WifiInformation.security()
    }
}

struct XyoSystemInfoPayloadCellularProviderStruct: Encodable {
    var name: String?
    var mcc: String?
    var mnc: String?
    var icc: String?
    var allowVoip: Bool?
    init() {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        let subscriberCellularProvider = networkInfo.subscriberCellularProvider
        name = subscriberCellularProvider?.carrierName
        mcc = subscriberCellularProvider?.mobileCountryCode
        mnc = subscriberCellularProvider?.mobileNetworkCode
        icc = subscriberCellularProvider?.isoCountryCode
        allowVoip = subscriberCellularProvider?.allowsVOIP
        #endif
    }
}

struct XyoSystemInfoPayloadCellularStruct: Encodable {
    var provider = XyoSystemInfoPayloadCellularProviderStruct()
    var radio: String?
    init() {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        radio = networkInfo.currentRadioAccessTechnology
        #endif
    }
}

struct XyoSystemInfoPayloadNetworkStruct: Encodable {
    var wifi = WifiInformation.isWifi() ? XyoSystemInfoPayloadWifiStruct() : nil
    var cellular = XyoSystemInfoPayloadCellularStruct()
    var reachability: String?
    init() {
        switch WifiInformation.reachability.connection {
        case .wifi:
            if (WifiInformation.isWifi()) {
                reachability = "wifi"
            } else if (WifiInformation.isEthernet()) {
                reachability = "ethernet"
            } else {
                reachability = "unknown"
            }
        case .cellular:
            reachability = "cellular"
        case .unavailable:
            reachability = "unavailable"
        default:
            reachability = nil
        }
    }
}

struct XyoSystemInfoPayloadDeviceStruct: Encodable {
    var model: String?
    var sysname: String?
    var nodename: String?
    var release: String?
    var version: String?
    init() {
        var systemInfo = utsname()
        uname(&systemInfo)
        model = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        sysname = withUnsafePointer(to: &systemInfo.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        nodename = withUnsafePointer(to: &systemInfo.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        release = withUnsafePointer(to: &systemInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        version = withUnsafePointer(to: &systemInfo.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
    }
}

open class XyoSystemInfoPayload: XyoPayload {
    
    init() {
        super.init("network.xyo.system.info")
    }
    
    enum CodingKeys: String, CodingKey {
        case os
        case network
        case device
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(XyoSystemInfoPayloadOsStruct(), forKey: .os)
        try container.encode(XyoSystemInfoPayloadNetworkStruct(), forKey: .network)
        try container.encode(XyoSystemInfoPayloadDeviceStruct(), forKey: .device)
    }
}
