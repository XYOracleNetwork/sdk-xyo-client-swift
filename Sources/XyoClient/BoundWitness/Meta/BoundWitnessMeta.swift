import Foundation

public protocol BoundWitnessMetaProtocol: Decodable {
    var client: String? { get set }
    var signatures: [String]? { get set }
}

public class BoundWitnessMeta: EncodableEmptyMeta, BoundWitnessMetaProtocol, Decodable {
    public var client: String?
    public var signatures: [String]?

    enum CodingKeys: String, CodingKey {
        case client = "$client"
        case signatures = "$signatures"
    }

    public init(_ signatures: [String] = []) {
        self.client = "ios"
        self.signatures = signatures
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        client = try values.decode(String.self, forKey: .client)
        signatures = try values.decode([String].self, forKey: .signatures)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.client, forKey: .client)
        try container.encode(self.signatures, forKey: .signatures)
    }
}
