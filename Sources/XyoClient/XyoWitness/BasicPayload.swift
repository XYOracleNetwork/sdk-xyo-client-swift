import Foundation

open class XyoBasicPayload: XyoPayload {
    
    let time_stamp = Date()
    
    init() {
        super.init("network.xyo.basic")
    }
    
    override init(_ schema: String) {
        super.init(schema)
    }
    
    enum CodingKeys: String, CodingKey {
        case time_stamp
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(time_stamp.timeIntervalSince1970 * 1000), forKey: .time_stamp)
    }
}
