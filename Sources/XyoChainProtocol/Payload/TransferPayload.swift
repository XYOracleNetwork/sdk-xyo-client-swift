import Foundation
import XyoClient

/// Payload for token transfers (`network.xyo.transfer`), matching the Android/JS `TransferPayload`.
open class TransferPayload: EncodablePayloadInstance {

    public static let schema = "network.xyo.transfer"

    public var from: String?
    public var transfers: [String: String]?
    public var epoch: Int64?
    public var context: [String: JSONValue]?

    public init(
        from: String? = nil,
        transfers: [String: String]? = nil,
        epoch: Int64? = nil,
        context: [String: JSONValue]? = nil
    ) {
        self.from = from
        self.transfers = transfers
        self.epoch = epoch
        self.context = context
        super.init(TransferPayload.schema)
    }

    enum CodingKeys: String, CodingKey {
        case schema, from, transfers, epoch, context
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(transfers, forKey: .transfers)
        try container.encodeIfPresent(epoch, forKey: .epoch)
        try container.encodeIfPresent(context, forKey: .context)
    }
}
