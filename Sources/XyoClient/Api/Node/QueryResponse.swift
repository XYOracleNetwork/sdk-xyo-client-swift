import Foundation

/// Parsed result of a node query: the response bound witness plus its returned payloads.
/// Mirrors the Android `QueryResponseWrapper`.
public final class QueryResponse {
    public let bw: EncodableBoundWitnessWithMeta?
    public let payloads: [AnyPayload]

    public init(bw: EncodableBoundWitnessWithMeta?, payloads: [AnyPayload]) {
        self.bw = bw
        self.payloads = payloads
    }

    /// The data hash of the response bound witness, if present.
    public func bwDataHash() throws -> Hash? {
        guard let bw = bw else { return nil }
        return try PayloadBuilder.dataHash(from: bw.typedPayload)
    }
}
