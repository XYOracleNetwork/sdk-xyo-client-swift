import Foundation

public class ModuleQueryResult: Codable {
    public let bw: EncodableBoundWitnessWithMeta
    public let payloads: [EncodablePayloadInstance]
    public let errors: [EncodablePayloadInstance]
    init(
        bw: EncodableBoundWitnessWithMeta,
        payloads: [EncodablePayloadInstance] = [],
        errors: [EncodablePayloadInstance] = []
    ) {
        self.bw = bw
        self.payloads = payloads
        self.errors = errors
    }
    public func encode(to encoder: Encoder) throws {
        // Create an unkeyed container for array encoding
        var container = encoder.unkeyedContainer()
        // Encode `bw` as the first element
        try container.encode(bw)
        // Encode `payloads` as the second element
        try container.encode(payloads)
        // Encode `errors` as the third element
        try container.encode(errors)
    }
    public required init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        // Decode elements in the expected order from the array
        bw = try container.decode(BoundWitnessWithMeta.self)
        // TODO: Decodable Payloads
        // payloads = try container.decode([XyoPayload].self)
        // errors = try container.decode([XyoPayload].self)
        payloads = []
        errors = []
    }
}
