import CoreTelephony
import Foundation

#if os(iOS)
    import SystemConfiguration.CaptiveNetwork
#endif

#if os(macOS)
    import CoreWLAN
#endif

public class WifiInformation {

    var pathMonitor: PathMonitorManager?

    public init(_ allowPathMonitor: Bool = false) {
        self.pathMonitor = allowPathMonitor ? PathMonitorManager(true) : nil
    }

    #if os(iOS)
        func ssid() -> String? {
            guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
                return nil
            }
            let ssids: [String] = interfaceNames.compactMap { name in
                guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject]
                else {
                    return nil
                }
                guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                    return nil
                }
                return ssid
            }
            return ssids.first
        }
    #elseif os(macOS)
        func ssid() -> String? {
            let client = CWWiFiClient.shared()
            let interface = client.interface(withName: nil)
            return interface?.ssid()
        }
    #else
        func ssid() -> String? {
            var ssid: String?
            if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                for interface in interfaces {
                    if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString)
                        as NSDictionary?
                    {
                        ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                        break
                    }
                }
            }
            return ssid
        }
    #endif

    #if os(macOS)
        func mac() -> String? {
            let client = CWWiFiClient.shared()
            let interface = client.interface(withName: nil)
            return interface?.hardwareAddress()
        }
    #else
        func mac() -> String? {
            return nil
        }
    #endif

    #if os(macOS)
        func security() -> String? {
            let client = CWWiFiClient.shared()
            let interface = client.interface(withName: nil)
            guard let security = interface?.security() else { return nil }
            switch security {
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
        func security() -> String? {
            return nil
        }
    #endif

    func isWifi() -> Bool {
        return pathMonitor?.isWifi ?? false
    }

    func isWired() -> Bool {
        return pathMonitor?.isWired ?? false
    }

    func isCellular() -> Bool {
        return pathMonitor?.isCellular ?? false
    }

    #if os(macOS)
        func rssi() -> Int? {
            let client = CWWiFiClient.shared()
            let interface = client.interface(withName: nil)
            return interface?.rssiValue()
        }
    #else
        func rssi() -> Int? {
            return nil
        }
    #endif

    #if os(macOS)
        func txPower() -> Int? {
            let client = CWWiFiClient.shared()
            let interface = client.interface(withName: nil)
            return interface?.transmitPower()
        }
    #else
        func txPower() -> Int? {
            return nil
        }
    #endif
}
