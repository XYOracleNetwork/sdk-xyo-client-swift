import Foundation
import Reachability
import CoreTelephony
import Network

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
    
    @available(iOS 12.0, *)
    static var pathMonitor = NWPathMonitor()
    
    static func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    print("name: \(name)")
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    static func getWifiIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    static func getCellularIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    static func getWiredIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wired = ["en2", "en3", "en4"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en2" || name == "en3" || name == "en4" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
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
        return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.wifi)
    }
    #else
    static func isWifi() -> Bool {
        if #available(iOS 12, *) {
            return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.wifi)
        } else {
            return WifiInformation.reachability.connection == .wifi
        }
    }
    #endif
    
    #if os(macOS)
    static func isLoopback() -> Bool {
        return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.loopback)
    }
    #else
    static func isLoopback() -> Bool {
        if #available(iOS 12, *) {
            return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.loopback)
        } else {
            return false
        }
    }
    #endif
    
    #if os(macOS)
    static func isCellular() -> Bool {
        return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.cellular)
    }
    #else
    static func isCellular() -> Bool {
        if #available(iOS 12, *) {
            return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.cellular)
        } else {
            return WifiInformation.reachability.connection == .cellular
        }
    }
    #endif
    
    #if os(macOS)
    static func isWired() -> Bool {
        let client = CWWiFiClient.shared()
        let interface = client.interface(withName: nil)
        let security = interface?.security() ?? .none
        return security == .unknown
    }
    #else
    static func isWired() -> Bool {
        if #available(iOS 12, *) {
            return WifiInformation.pathMonitor.currentPath.usesInterfaceType(.wiredEthernet)
        } else {
            return false
        }
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

struct XyoSystemInfoOsVersionPayloadStruct: Encodable {
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

struct XyoSystemInfoOsPayloadStruct: Encodable {
    var version = XyoSystemInfoOsVersionPayloadStruct()
    var name: String
    init() {
        name = SystemInformation.osName()
    }
}

struct XyoSystemInfoNetworkWifiPayloadStruct: Encodable {
    var ssid: String?
    var mac: String?
    var on: Bool?
    var rssi: Int?
    var txPower: Int?
    var security: String?
    var ip: String?
    init() {
        ssid = WifiInformation.ssid()
        mac = WifiInformation.mac()
        on = WifiInformation.on()
        rssi = WifiInformation.rssi()
        txPower = WifiInformation.txPower()
        security = WifiInformation.security()
        ip = WifiInformation.getWifiIPAddress()
    }
}

struct XyoSystemInfoCellularProviderPayloadStruct: Encodable {
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

struct XyoSystemInfoNetworkCellularPayloadStruct: Encodable {
    var provider = XyoSystemInfoCellularProviderPayloadStruct()
    var radio: String?
    var ip: String?
    init() {
        #if os(iOS)
        let networkInfo = CTTelephonyNetworkInfo()
        radio = networkInfo.currentRadioAccessTechnology
        #endif
        ip = WifiInformation.getCellularIPAddress()
    }
}

struct XyoSystemInfoNetworkWiredPayloadStruct: Encodable {
    var ip: String?
    init() {
        ip = WifiInformation.getIPAddress()
    }
}

struct XyoSystemInfoNetworkPayloadStruct: Encodable {
    var wifi = WifiInformation.isWifi() ? XyoSystemInfoNetworkWifiPayloadStruct() : nil
    var cellular = XyoSystemInfoNetworkCellularPayloadStruct()
    var wired = XyoSystemInfoNetworkWiredPayloadStruct()
    var reachability: String?
    var ip: String?
    init() {
        switch WifiInformation.reachability.connection {
        case .wifi:
            if (WifiInformation.isWifi()) {
                reachability = "wifi"
            } else if (WifiInformation.isWired()) {
                reachability = "wired"
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
        ip = WifiInformation.getIPAddress()
    }
}

struct XyoSystemInfoDevicePayloadStruct: Encodable {
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
        try container.encode(XyoSystemInfoOsPayloadStruct(), forKey: .os)
        try container.encode(XyoSystemInfoNetworkPayloadStruct(), forKey: .network)
        try container.encode(XyoSystemInfoDevicePayloadStruct(), forKey: .device)
    }
}
