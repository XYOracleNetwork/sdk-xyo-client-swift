import Foundation

/// Payload for network addresses, matching JS `@xyo-network/address-payload-plugin`.
open class AddressPayload: EncodablePayloadInstance {

    public static let schema: String = Schemas.address

    public var address: String?
    public var name: String?

    public init(address: String? = nil, name: String? = nil) {
        self.address = address
        self.name = name
        super.init(AddressPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case address
        case name
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.address, forKey: .address)
        try container.encodeIfPresent(self.name, forKey: .name)
    }
}
