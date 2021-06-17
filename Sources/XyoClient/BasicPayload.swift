import Foundation

open class XyoBasicPayload: XyoPayload {
    
    let time_stamp = Date()
    
    enum CodingKeys: String, CodingKey {
        case schema
        case time_stamp
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("basic", forKey: .schema)
        try container.encode(time_stamp.timeIntervalSince1970, forKey: .time_stamp)
    }
}
