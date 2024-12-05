open class IdPayload: EncodablePayloadInstance {

    public static let schema: String = "network.xyo.id"

    var salt: String

    public init(salt: String) {
        self.salt = salt
        super.init(IdPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case salt
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encode(self.salt, forKey: .salt)
    }
}

