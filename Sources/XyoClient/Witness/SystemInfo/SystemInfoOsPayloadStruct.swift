import Foundation

struct SystemInfoOsPayloadStruct: Encodable {
    var name: String
    var version = SystemInfoOsVersionPayloadStruct()
    init() {
        name = osName()
    }
}
