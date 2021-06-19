import Foundation

struct XyoSystemInfoOsPayloadStruct: Encodable {
    var version = XyoSystemInfoOsVersionPayloadStruct()
    var name: String
    init() {
        name = osName()
    }
}
