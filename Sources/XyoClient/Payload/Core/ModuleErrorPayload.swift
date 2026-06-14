import Foundation

/// Module error payload, matching JS `ModuleError` (XYO Yellow Paper Section 1.4).
open class ModuleErrorPayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.moduleError

    public var message: String?
    public var name: String?
    public var query: String?

    public init(message: String? = nil, name: String? = nil, query: String? = nil) {
        self.message = message
        self.name = name
        self.query = query
        super.init(ModuleErrorPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case message
        case name
        case query
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.query, forKey: .query)
    }
}
