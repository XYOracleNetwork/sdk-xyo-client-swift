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
            print("Name: \(self.name!)")
            self.connected = path.status == .satisfied
            print("Connected: \(self.connected!)")
            self.isWifi = path.usesInterfaceType(.wifi)
            print("Wifi: \(self.isWifi!)")
            self.isCellular = path.usesInterfaceType(.cellular)
            print("Cellular: \(self.isCellular!)")
            self.isWired = path.usesInterfaceType(.wiredEthernet)
            print("Wired: \(self.isWired!)")
            
            if #available(iOS 13, *) {
                if let endpoint = path.gateways.first {
                    switch endpoint {
                    case .hostPort(let host, _):
                        self.ip = host.debugDescription
                        break
                    default:
                        break
                    }
                } else {
                    self.ip = nil
                }
            } else {
                self.ip = nil
            }

            print("Ip: \(self.ip!)")
        }
    }
}
