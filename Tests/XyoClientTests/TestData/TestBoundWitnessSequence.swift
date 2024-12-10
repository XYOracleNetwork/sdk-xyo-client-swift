import XyoClient

public struct BoundWitnessSequenceTestCase {
    public var mnemonics: [String]
    public var paths: [String]
    public var addresses: [String]
    public var payloads: [EncodablePayloadInstance]
    public var payloadHashes: [String]
    public var previousHashes: [String?]
    public var dataHash: String
    public var rootHash: String
}

public struct PayloadsWithHashes {
    public var payloads: [EncodablePayloadInstance]
    public var payloadHashes: [String]
}

let payloadSequences: [PayloadsWithHashes] = [
    .init(
        payloads: [IdPayload(0)],
        payloadHashes: [
            "ada56ff753c0c9b2ce5e1f823eda9ac53501db2843d8883d6cf6869c18ef7f65"
        ]
    ),
    .init(
        payloads: [IdPayload(1)],
        payloadHashes: [
            "3a3b8deca568ff820b0b7c8714fbdf82b40fb54f4b15aca8745e06b81291558e"
        ]
    ),
    .init(
        payloads: [IdPayload(2), IdPayload(3)],
        payloadHashes: [
            "1a40207fab71fc184e88557d5bee6196cbbb49f11f73cda85000555a628a8f0a",
            "c4bce9b4d3239fcc9a248251d1bef1ba7677e3c0c2c43ce909a6668885b519e6",
        ]
    ),
    .init(
        payloads: [IdPayload(4), IdPayload(5)],
        payloadHashes: [
            "59c0374dd801ae64ddddba27320ca028d7bd4b3d460f6674c7da1b4aa9c956d6",
            "5d9b8e84bc824280fcbb6290904c2edbb401d626ad9789717c0a23d1cab937b0",
        ]
    ),
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
    previousHashes: [nil],
    dataHash: "750113b9826ba94b622667b06cd8467f1330837581c28907c16160fec20d0a4b",
    rootHash: "d8c29f77505e5da7479de1aa6474b247b348004a90bf7048e60581592deac1e7"
)

let boundWitnessSequenceTestCase2: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet2Mnemonic],
    paths: [wallet2Path],
    addresses: [wallet2Address],
    payloads: payloadSequences[1].payloads,
    payloadHashes: payloadSequences[1].payloadHashes,
    previousHashes: [nil],
    dataHash: "bacd010d79126a154339e59c11c5b46be032c3bef65626f83bcafe968dc6dd1b",
    rootHash: "ea1d3dd28daea3df2c7d50ffcecec3be95c8011636a6590598a4aab0ce2b6971"
)

let boundWitnessSequenceTestCase3: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet1Mnemonic, wallet2Mnemonic],
    paths: [wallet1Path, wallet2Path],
    addresses: [wallet1Address, wallet2Address],
    payloads: payloadSequences[2].payloads,
    payloadHashes: payloadSequences[2].payloadHashes,
    previousHashes: [
        "750113b9826ba94b622667b06cd8467f1330837581c28907c16160fec20d0a4b",
        "bacd010d79126a154339e59c11c5b46be032c3bef65626f83bcafe968dc6dd1b",
    ],
    dataHash: "73245ef73517913f4b57c12d56d81199968ecd8fbefea9ddc474f43dd6cfa8c8",
    rootHash: "02caf1f81905ec9311b3b4793309f462567b35516d7dee7ce62d1e4759b7022a"
)

let boundWitnessSequenceTestCase4: BoundWitnessSequenceTestCase = .init(
    mnemonics: [wallet1Mnemonic, wallet2Mnemonic],
    paths: [wallet1Path, wallet2Path],
    addresses: [wallet1Address, wallet2Address],
    payloads: payloadSequences[3].payloads,
    payloadHashes: payloadSequences[3].payloadHashes,
    previousHashes: [
        "73245ef73517913f4b57c12d56d81199968ecd8fbefea9ddc474f43dd6cfa8c8",
        "73245ef73517913f4b57c12d56d81199968ecd8fbefea9ddc474f43dd6cfa8c8",
    ],
    dataHash: "210d86ea43d82b85a49b77959a8ee4e6016ff7036254cfa39953befc66073010",
    rootHash: "a99467084abb2d7812f4d529a2e84d566716aca9443c4b4800e016572cf91416"
)

let boundWitnessSequenceTestCases = [
    boundWitnessSequenceTestCase1,
    boundWitnessSequenceTestCase2,
    boundWitnessSequenceTestCase3,
    boundWitnessSequenceTestCase4,
]
