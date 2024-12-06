import Foundation

class SystemInfoDevicePayloadStruct: Encodable, Decodable {
    var model: String?
    var nodename: String?
    var release: String?
    var sysname: String?
    var version: String?

    init() {

    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.model = try values.decode(String.self, forKey: .model)
        self.nodename = try values.decode(String.self, forKey: .nodename)
        self.release = try values.decode(String.self, forKey: .release)
        self.sysname = try values.decode(String.self, forKey: .sysname)
        self.version = try values.decode(String.self, forKey: .version)
    }

    enum CodingKeys: String, CodingKey {
        case model
        case nodename
        case release
        case sysname
        case version
    }

    static func load() -> SystemInfoDevicePayloadStruct {
        var result = SystemInfoDevicePayloadStruct()
        var systemInfo = utsname()
        uname(&systemInfo)
        result.model = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        result.sysname = withUnsafePointer(to: &systemInfo.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        result.nodename = withUnsafePointer(to: &systemInfo.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        result.release = withUnsafePointer(to: &systemInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        result.version = withUnsafePointer(to: &systemInfo.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String(validatingUTF8: ptr)
            }
        }?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return result
    }
}
