import Foundation

open class EncodablePayload: Encodable {
    public init(_ schema: String) {
        self.schema = schema.lowercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    public var schema: String
    
    
    public func hash() throws -> Hash {
        return try PayloadBuilder.hash(from: self)
    }
    
    public func dataHash() throws -> Hash {
        return try PayloadBuilder.dataHash(from: self)
    }
    
    public func toJson() throws -> String {
        return try PayloadBuilder.toJson(from: self)
    }
}

open class Payload: EncodablePayload, Decodable {
    
    override public init(_ schema: String) {
        super.init(schema)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let schema = try values.decode(String.self, forKey: .schema)
        super.init(schema)
    }
}
