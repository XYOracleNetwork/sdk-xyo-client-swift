import Foundation

/// Payload bundle containing multiple payloads with a root reference
/// (XYO Yellow Paper Section 1.5), matching the Android `PayloadBundle`.
open class PayloadBundle: EncodablePayloadInstance {

    public static let schema: String = Schemas.payloadBundle

    public var root: String?

    public init(root: String? = nil) {
        self.root = root
        super.init(PayloadBundle.schema)
    }

    enum CodingKeys: String, CodingKey {
        case root
        case schema
    }

    override open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.schema, forKey: .schema)
        try container.encodeIfPresent(self.root, forKey: .root)
    }
}
