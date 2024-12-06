import Foundation

public protocol PayloadFields: Encodable {
    var schema: String { get }
}

public protocol EncodablePayload: PayloadFields, Encodable {}

public protocol Payload: PayloadFields, EncodablePayload, Decodable {}

open class EncodablePayloadInstance: EncodablePayload {
    public init(_ schema: String) {
        self.schema = schema.lowercased()
    }

    enum CodingKeys: String, CodingKey {
        case schema
    }

    public var schema: String

    public func toJson() throws -> String {
        return try PayloadBuilder.toJson(from: self)
    }
}

open class PayloadInstance: EncodablePayloadInstance, Payload {

    override public init(_ schema: String) {
        super.init(schema)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let schema = try values.decode(String.self, forKey: .schema)
        super.init(schema)
    }
}
