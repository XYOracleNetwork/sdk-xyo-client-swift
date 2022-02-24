import Foundation

struct XyoSystemInfoDevicePayloadStruct: Encodable {
    var model: String?
    var nodename: String?
    var release: String?
    var sysname: String?
    var version: String?
    init() {
        var systemInfo = utsname()
        uname(&systemInfo)
        model = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        sysname = withUnsafePointer(to: &systemInfo.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        nodename = withUnsafePointer(to: &systemInfo.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        release = withUnsafePointer(to: &systemInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        version = withUnsafePointer(to: &systemInfo.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
