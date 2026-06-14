import Foundation

/// Payload for generic values, matching JS `@xyo-network/value-payload-plugin`.
open class ValuePayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.value

    public var value: JSONValue?

    public init(value: JSONValue? = nil) {
        self.value = value
        super.init(ValuePayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case value
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.value, forKey: .value)
    }
}
