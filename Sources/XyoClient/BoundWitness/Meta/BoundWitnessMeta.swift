import Foundation

public protocol BoundWitnessMetaProtocol: Decodable {
    var signatures: [String]? { get set }
    var destination: String? { get set }
    var sourceQuery: String? { get set }
}

/// Client (`$`-prefixed) meta fields of a BoundWitness. These are included in the root
/// `hash()` but excluded from the signed `dataHash()`. The field set matches the
/// authoritative JS model and the Android SDK: `$signatures`, `$destination`, `$sourceQuery`.
/// (The legacy Swift-only `$client` field has been removed for cross-SDK conformance.)
public class BoundWitnessMeta: EncodableEmptyMeta, BoundWitnessMetaProtocol, Decodable {
    public var signatures: [String]?
    public var destination: String?
    public var sourceQuery: String?

    enum CodingKeys: String, CodingKey {
        case signatures = "$signatures"
        case destination = "$destination"
        case sourceQuery = "$sourceQuery"
    }

    public init(_ signatures: [String] = []) {
        self.signatures = signatures
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        signatures = try values.decodeIfPresent([String].self, forKey: .signatures)
        destination = try values.decodeIfPresent(String.self, forKey: .destination)
        sourceQuery = try values.decodeIfPresent(String.self, forKey: .sourceQuery)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.signatures, forKey: .signatures)
        try container.encodeIfPresent(self.destination, forKey: .destination)
        try container.encodeIfPresent(self.sourceQuery, forKey: .sourceQuery)
    }
}
