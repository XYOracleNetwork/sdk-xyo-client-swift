import Foundation

/// Payload for schema definitions, matching JS `@xyo-network/schema-payload-plugin`.
open class SchemaPayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.schema

    public var definition: JSONValue?

    public init(definition: JSONValue? = nil) {
        self.definition = definition
        super.init(SchemaPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case definition
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.definition, forKey: .definition)
    }
}
