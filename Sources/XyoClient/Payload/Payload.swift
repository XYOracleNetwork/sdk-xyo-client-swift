import Foundation

open class EncodablePayload: Encodable {
    public init(_ schema: String) {
        self.schema = schema.lowercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    public var schema: String
}

extension EncodablePayload {
    public func hash() throws -> Hash {
        return try BoundWitnessBuilder.hash(self)
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
