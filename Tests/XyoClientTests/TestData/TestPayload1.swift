import XyoClient

public class TestPayload1SubObject: Encodable {
    var number_value = 2
    var string_value = "yo"
}

public class TestPayload1: Payload {
    var timestamp = 1_618_603_439_107
    var number_field = 1
    var object_field = TestPayload1SubObject()
    var string_field = "there"

    enum CodingKeys: String, CodingKey {
        case schema
        case timestamp
        case number_field
        case object_field
        case string_field
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number_field, forKey: .number_field)
        try container.encode(object_field, forKey: .object_field)
        try container.encode(schema, forKey: .schema)
        try container.encode(string_field, forKey: .string_field)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

let testPayload1 = TestPayload1("network.xyo.test")
let testPayload1Hash: Hash = "a5bd50ec40626d390017646296f6a6ac2938ff2e952b2a27b1467a7ef44cdf35"
