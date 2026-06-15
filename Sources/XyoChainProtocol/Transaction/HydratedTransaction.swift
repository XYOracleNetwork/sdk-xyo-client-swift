import Foundation
import XyoClient

/// A transaction bound witness paired with its payloads, matching the Android `HydratedTransaction`.
public struct HydratedTransaction {
    public let boundWitness: TransactionBoundWitness
    public let payloads: [EncodablePayloadInstance]

    public init(boundWitness: TransactionBoundWitness, payloads: [EncodablePayloadInstance]) {
        self.boundWitness = boundWitness
        self.payloads = payloads
    }
}
