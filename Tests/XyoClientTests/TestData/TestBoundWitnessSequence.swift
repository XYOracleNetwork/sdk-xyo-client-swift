import XyoClient

public struct BoundWitnessSequenceTestCase {
    public var mnemonics: [String]
    public var paths: [String]
    public var addresses: [String]
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

let wallet1Mnemonic =
    "report door cry include salad horn recipe luxury access pledge husband maple busy double olive"
let wallet1Path = "m/44'/60'/0'/0/0"
let wallet1Address = "25524Ca99764D76CA27604Bb9727f6e2f27C4533"

let wallet2Mnemonic =
    "turn you orphan sauce act patient village entire lava transfer height sense enroll quit idle"
let wallet2Path = "m/44'/60'/0'/0/0"
let wallet2Address = "FdCeD2c3549289049BeBf743fB721Df211633fBF"

let boundWitnessSequenceTestCase1: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet1Mnemonic],
    paths: [wallet1Path],
    addresses: [wallet1Address],
    payloads: payloadSequences[0].payloads,
    payloadHashes: payloadSequences[0].payloadHashes,
    previousHashes: [nil, nil],
    dataHash: ""
)

let boundWitnessSequenceTestCase2: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet2Mnemonic],
    paths: [wallet2Path],
    addresses: [wallet2Address],
    payloads: payloadSequences[1].payloads,
    payloadHashes: payloadSequences[1].payloadHashes,
    previousHashes: [],
    dataHash: ""
)

let boundWitnessSequenceTestCase3: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet1Mnemonic, wallet2Mnemonic],
    paths: [wallet1Path, wallet2Path],
    addresses: [wallet1Address, wallet2Address],
    payloads: payloadSequences[2].payloads,
    payloadHashes: payloadSequences[2].payloadHashes,
    previousHashes: [],
    dataHash: ""
)

let boundWitnessSequenceTestCases = [
    boundWitnessSequenceTestCase1, boundWitnessSequenceTestCase2, boundWitnessSequenceTestCase3,
]
