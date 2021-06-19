import Foundation
import Network

class PathMonitorManager {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    var connected: Bool?
    var name: String?
    var ip: String?
    var isWifi: Bool?
    var isCellular: Bool?
    var isWired: Bool?
    var ready = false
    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.ready = true
            self.name = path.availableInterfaces[0].name
            self.ip = PathMonitorManager.getIPAddress(self.name)
            print("Name: \(self.name!)")
            self.connected = path.status == .satisfied
            print("Connected: \(self.connected!)")
            self.isWifi = path.usesInterfaceType(.wifi)
            print("Wifi: \(self.isWifi!)")
            self.isCellular = path.usesInterfaceType(.cellular)
            print("Cellular: \(self.isCellular!)")
            self.isWired = path.usesInterfaceType(.wiredEthernet)
            print("Wired: \(self.isWired!)")
        }
    }
    
    static func getIPAddress(_ name: String? = nil) -> String? {
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

                    let foundName: String = String(cString: (interface.ifa_name))
                    if  name == nil || name == foundName {
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
}
