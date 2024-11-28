import Foundation

public class BoundWitnessWithMeta: Payload
{
    public var _hash: String? = nil
    public var _meta: BoundWitnessMeta? = nil
    private var _boundWitness: BoundWitness
    
    public var boundWitness: BoundWitness {
        return _boundWitness
    }

    enum CodingKeys: String, CodingKey {
        case _hash = "$hash"
        case _meta = "$meta"
    }
    
    init(boundWitness: BoundWitness = BoundWitness(), meta: BoundWitnessMeta = BoundWitnessMeta()) {
        _boundWitness = boundWitness
        _meta = meta
        super.init(BoundWitnessSchema)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _hash = try values.decodeIfPresent(String.self, forKey: ._hash)
        _meta = try values.decodeIfPresent(BoundWitnessMeta.self, forKey: ._meta)
        _boundWitness = try BoundWitness(from: decoder)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_hash, forKey: ._hash)
        try container.encode(_meta, forKey: ._meta)
        try _boundWitness.encode(to: encoder)
        try super.encode(to: encoder)
    }
}
