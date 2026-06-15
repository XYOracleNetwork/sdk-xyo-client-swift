import Foundation
import XyoClient

/// A signed XL1 transaction bound witness, matching the Android `TransactionBoundWitness`.
/// `schema` is `network.xyo.boundwitness`; `$signatures` carries the signer signatures.
public struct TransactionBoundWitness: Codable, Equatable {
    public static let schema = "network.xyo.boundwitness"

    public let from: String
    public let chain: ChainId
    public let nbf: Int64
    public let exp: Int64
    public let fees: TransactionFeesHex
    public let script: [String]?
    public let addresses: [String]
    public let payload_hashes: [String]
    public let payload_schemas: [String]
    public let previous_hashes: [String?]
    public let schema: String
    public let timestamp: Int64?
    public let signatures: [String]?

    public init(
        from: String, chain: ChainId, nbf: Int64, exp: Int64, fees: TransactionFeesHex,
        script: [String]? = nil, addresses: [String] = [], payload_hashes: [String] = [],
        payload_schemas: [String] = [], previous_hashes: [String?] = [],
        schema: String = TransactionBoundWitness.schema, timestamp: Int64? = nil,
        signatures: [String]? = nil
    ) {
        self.from = from
        self.chain = chain
        self.nbf = nbf
        self.exp = exp
        self.fees = fees
        self.script = script
        self.addresses = addresses
        self.payload_hashes = payload_hashes
        self.payload_schemas = payload_schemas
        self.previous_hashes = previous_hashes
        self.schema = schema
        self.timestamp = timestamp
        self.signatures = signatures
    }

    enum CodingKeys: String, CodingKey {
        case from, chain, nbf, exp, fees, script, addresses
        case payload_hashes, payload_schemas, previous_hashes, schema, timestamp
        case signatures = "$signatures"
    }

    public var nbfBlockNumber: XL1BlockNumber { XL1BlockNumber(nbf) }
    public var expBlockNumber: XL1BlockNumber { XL1BlockNumber(exp) }
}

/// The unsigned, data-hashable form of a transaction bound witness, used to compute the hash
/// that signers sign. Encoded with no `$signatures` (the data hash excludes client meta anyway).
final class SignableTransactionBoundWitness: EncodablePayloadInstance {
    let from: String
    let chain: ChainId
    let nbf: Int64
    let exp: Int64
    let fees: TransactionFeesHex
    let script: [String]?
    let addresses: [String]
    let payload_hashes: [String]
    let payload_schemas: [String]
    let previous_hashes: [String?]
    let timestamp: Int64?

    init(
        from: String, chain: ChainId, nbf: Int64, exp: Int64, fees: TransactionFeesHex,
        script: [String]?, addresses: [String], payload_hashes: [String],
        payload_schemas: [String], previous_hashes: [String?], timestamp: Int64?
    ) {
        self.from = from
        self.chain = chain
        self.nbf = nbf
        self.exp = exp
        self.fees = fees
        self.script = script
        self.addresses = addresses
        self.payload_hashes = payload_hashes
        self.payload_schemas = payload_schemas
        self.previous_hashes = previous_hashes
        self.timestamp = timestamp
        super.init(TransactionBoundWitness.schema)
    }

    enum CodingKeys: String, CodingKey {
        case from, chain, nbf, exp, fees, script, addresses
        case payload_hashes, payload_schemas, previous_hashes, schema, timestamp
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from, forKey: .from)
        try container.encode(chain, forKey: .chain)
        try container.encode(nbf, forKey: .nbf)
        try container.encode(exp, forKey: .exp)
        try container.encode(fees, forKey: .fees)
        try container.encodeIfPresent(script, forKey: .script)
        try container.encode(addresses, forKey: .addresses)
        try container.encode(payload_hashes, forKey: .payload_hashes)
        try container.encode(payload_schemas, forKey: .payload_schemas)
        try container.encode(previous_hashes, forKey: .previous_hashes)
        try container.encode(schema, forKey: .schema)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
    }
}
