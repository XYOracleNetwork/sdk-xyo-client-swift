import Foundation

/// Payload for domain/URL information, matching JS `@xyo-network/domain-payload-plugin`.
open class DomainPayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.domain

    public var domain: String?
    public var aliases: JSONValue?

    public init(domain: String? = nil, aliases: JSONValue? = nil) {
        self.domain = domain
        self.aliases = aliases
        super.init(DomainPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case domain
        case aliases
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.domain, forKey: .domain)
        try container.encodeIfPresent(self.aliases, forKey: .aliases)
    }
}
