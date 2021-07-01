import Foundation

open class XyoEventPayload: XyoPayload {
    
    let time_stamp = Date()
    let event: String
    
    override init(_ event: String, _ previousHash: String?) {
        self.event = event
        super.init("network.xyo.event", previousHash)
    }
    
    enum CodingKeys: String, CodingKey {
        case time_stamp
        case event
    }
    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(time_stamp.timeIntervalSince1970 * 1000), forKey: .time_stamp)
        try container.encode(event, forKey: .event)
    }
}
