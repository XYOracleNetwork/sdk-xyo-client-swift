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
        // Decode elements in the expected order from the array: [bw, payloads, errors].
        bw = try container.decode(BoundWitnessWithMeta.self)
        // Payloads and errors are heterogeneous — decode into type-erased AnyPayload.
        payloads = (try? container.decode([AnyPayload].self)) ?? []
        errors = (try? container.decode([AnyPayload].self)) ?? []
    }
}
