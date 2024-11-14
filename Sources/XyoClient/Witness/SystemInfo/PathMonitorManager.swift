import Foundation
import Network

#if os(iOS)
    import UIKit
#endif

public class PathMonitorManager {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    // we create a group to prevent deinit while still processing on another thread
    let group = DispatchGroup()
    var connected: Bool?
    var name: String?
    var ip: String?
    var isWifi: Bool?
    var isCellular: Bool?
    var isWired: Bool?
    var ready = false
    var shuttingDown = false

    public init(_ start: Bool = true) {
        #if os(iOS)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applicationWillEnterForeground(notification:)),
                name: UIApplication.willEnterForegroundNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applicationWillResignActive(notification:)),
                name: UIApplication.willResignActiveNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applicationWillResignActive(notification:)),
                name: UIApplication.willTerminateNotification,
                object: nil)
        #endif
        if start {
            self.start()
        }
    }

    deinit {
        stop()
    }

    @objc func applicationWillEnterForeground(notification: Notification) {
        self.start()
    }

    @objc func applicationWillResignActive(notification: Notification) {
        self.stop()
    }

    @objc func applicationWillTerminate(notification: Notification) {
        self.stop()
    }

    func start() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            // bail if shutting down
            if self.shuttingDown {
                return
            }
            self.group.enter()
            self.ready = true
            self.name = path.availableInterfaces.first?.name
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
                    default:
                        break
                    }
                } else {
                    self.ip = nil
                }
            } else {
                self.ip = nil
            }

            self.group.leave()
        }
    }

    func stop() {
        // stop processing new dispatches
        shuttingDown = true

        // stop generating new dispatches
        monitor.cancel()

        // wait for any last dispatch, if any, to finish
        group.wait()
    }
}
