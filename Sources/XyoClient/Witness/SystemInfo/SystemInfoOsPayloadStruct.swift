import Foundation

struct XyoSystemInfoOsPayloadStruct: Encodable {
    var name: String
    var version = XyoSystemInfoOsVersionPayloadStruct()
    init() {
        name = osName()
    }
}
