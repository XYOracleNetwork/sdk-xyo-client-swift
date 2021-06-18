import Foundation

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
    init() {
        ssid = WifiInformation.ssid()
        mac = WifiInformation.mac()
        on = WifiInformation.on()
        rssi = WifiInformation.rssi()
        txPower = WifiInformation.txPower()
    }
}

open class XyoSystemInfoPayload: XyoPayload {
    
    init() {
        super.init("network.xyo.system.info")
    }
    
    enum CodingKeys: String, CodingKey {
        case os
        case wifi
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(XyoSystemInfoPayloadOsStruct(), forKey: .os)
        try container.encode(XyoSystemInfoPayloadWifiStruct(), forKey: .wifi)
    }
}
