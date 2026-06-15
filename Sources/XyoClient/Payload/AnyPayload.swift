import Foundation

/// A decodable payload that preserves arbitrary JSON fields. Used to decode the heterogeneous
/// payload arrays in node/archivist responses, mirroring the Android approach of parsing into a
/// base payload and re-decoding into concrete types on demand.
public final class AnyPayload: PayloadInstance {

    /// The full JSON object of the payload, including `schema`.
    public let json: [String: JSONValue]

    public init(json: [String: JSONValue]) {
        self.json = json
        if case .string(let schema)? = json["schema"] {
            super.init(schema)
        } else {
            super.init("")
        }
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let object = try container.decode([String: JSONValue].self)
        self.json = object
        if case .string(let schema)? = object["schema"] {
            super.init(schema)
        } else {
            super.init("")
        }
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(json)
    }

    // MARK: Typed accessors

    public func string(_ key: String) -> String? {
        if case .string(let value)? = json[key] { return value }
        return nil
    }

    public func int(_ key: String) -> Int? {
        if case .int(let value)? = json[key] { return value }
        return nil
    }

    public func bool(_ key: String) -> Bool? {
        if case .bool(let value)? = json[key] { return value }
        return nil
    }

    public func array(_ key: String) -> [JSONValue]? {
        if case .array(let value)? = json[key] { return value }
        return nil
    }

    public func object(_ key: String) -> [String: JSONValue]? {
        if case .object(let value)? = json[key] { return value }
        return nil
    }

    /// Re-decode this payload into a concrete `Decodable` type.
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let data = try JSONEncoder().encode(JSONValue.object(json))
        return try JSONDecoder().decode(type, from: data)
    }
}
