import Foundation

/// Payload for configuration data, matching JS `@xyo-network/config-payload-plugin`.
open class ConfigPayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.config

    public var config: JSONValue?

    public init(config: JSONValue? = nil) {
        self.config = config
        super.init(ConfigPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case config
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.config, forKey: .config)
    }
}
