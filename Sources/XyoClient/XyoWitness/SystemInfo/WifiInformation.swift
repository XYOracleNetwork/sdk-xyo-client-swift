import Foundation
import CoreTelephony

#if os(iOS)
import SystemConfiguration.CaptiveNetwork
#endif

#if os(macOS)
import CoreWLAN
#endif

class WifiInformation {
    
    static var pathMonitor = PathMonitorManager()
    
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
    
    static func isWifi() -> Bool {
        return WifiInformation.pathMonitor.isWifi ?? false
    }
    
    static func isWired() -> Bool {
        return WifiInformation.pathMonitor.isWired ?? false
    }
    
    static func isCellular() -> Bool {
        return WifiInformation.pathMonitor.isCellular ?? false
    }
    
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
