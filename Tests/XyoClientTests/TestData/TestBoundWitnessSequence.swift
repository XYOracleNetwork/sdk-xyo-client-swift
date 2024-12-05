import XyoClient

public struct BoundWitnessSequenceTestCase {
    public var privateKeys: [String]
    public var addresses: [Address]
    public var payloads: [EncodablePayloadInstance]
    public var payloadHashes: [String]
    public var previousHashes: [String?]
    public var dataHash: String
}

public struct PayloadsWithHashes {
    public var payloads: [EncodablePayloadInstance]
    public var payloadHashes: [String]
}

let payloadSequences: [PayloadsWithHashes] = [
    .init(payloads: [IdPayload(0)], payloadHashes: [""]),
    .init(payloads: [IdPayload(1)], payloadHashes: [""]),
    .init(payloads: [IdPayload(2), IdPayload(3)], payloadHashes: ["", ""]),

]

let boundWitnessSequenceTestCase1: BoundWitnessSequenceTestCase = .init(
    privateKeys: [],
    addresses: [],
    payloads: payloadSequences[0].payloads,
    payloadHashes: payloadSequences[0].payloadHashes,
    previousHashes: [nil , nil],
    dataHash: ""
)

let boundWitnessSequenceTestCase2: BoundWitnessSequenceTestCase = .init(
    privateKeys: [],
    addresses: [],
    payloads: payloadSequences[1].payloads,
    payloadHashes: payloadSequences[1].payloadHashes,
    previousHashes: [],
    dataHash: ""
)

let boundWitnessSequenceTestCase3: BoundWitnessSequenceTestCase = .init(
    privateKeys: [],
    addresses: [],
    payloads: payloadSequences[2].payloads,
    payloadHashes: payloadSequences[2].payloadHashes,
    previousHashes: [],
    dataHash: ""
)

let boundWitnessSequenceTestCases = [
    boundWitnessSequenceTestCase1, boundWitnessSequenceTestCase2, boundWitnessSequenceTestCase3,
]
