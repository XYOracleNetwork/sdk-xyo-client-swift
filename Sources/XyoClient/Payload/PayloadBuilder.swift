import Foundation

public enum PayloadBuilderError: Error {
    case encodingError
}

/// Merges multiple `Encodable` objects into a single JSON object.
///
/// This method accepts a variable number of `Encodable` objects, encodes each into JSON, converts them into dictionaries, and merges the dictionaries into one. In case of key conflicts, the value from the latter object will overwrite the earlier value. The final merged dictionary is then serialized back into JSON data.
///
/// - Parameters:
///   - encodables: A variadic list of objects conforming to the `Encodable` protocol.
///
/// - Returns: A `Data` object representing the merged JSON of all provided `Encodable` objects.
///
/// - Throws:
///   - An error if any of the `Encodable` objects fail to encode.
///   - An error if the JSON data cannot be converted to a dictionary or serialized.
func mergeToJsonObject(_ encodables: (any Encodable)...) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys

    // Initialize an empty dictionary to store merged data
    var mergedDict: [String: Any] = [:]

    for encodable in encodables {
        // Encode the current object into JSON data
        let data = try encoder.encode(encodable)

        // Decode the JSON into a dictionary
        if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            // Merge the current dictionary with the existing merged dictionary
            mergedDict.merge(dict) { (_, new) in new }
        }
    }

    // Serialize the merged dictionary back into JSON
    return try JSONSerialization.data(withJSONObject: mergedDict, options: .sortedKeys)
}

public protocol EncodableWithMeta: Encodable {
    var payload: EncodablePayload { get }
    var meta: Encodable? { get }
    func toJson() throws -> String
}

public struct AnyEncodableWithMeta<T: EncodableWithMeta>: EncodableWithMeta {
    private let _item: T

    public init(_ from: T) {
        self._item = from
    }

    public var payload: EncodablePayload {
        return self._item.payload
    }

    public var meta: Encodable? {
        return self._item.meta
    }

    public func toJson() throws -> String {
        return try self._item.toJson()
    }

    public func encode(to: Encoder) throws {
        return try self._item.encode(to: to)
    }
}

public class EncodableEmptyMeta: Encodable {}

public class EmptyMeta: Codable {}

public class EncodableWithMetaInstance<T: EncodablePayload>: EncodableWithCustomMetaInstance<
    T, EncodableEmptyMeta
> {
    public init(from: T) {
        super.init(from: from, meta: nil)
    }
}

public class EncodableWithCustomMetaInstance<T: EncodablePayload, M: Encodable>: EncodableWithMeta {
    var _meta: M?
    var _payload: T

    public var payload: EncodablePayload {
        return self._payload
    }

    public var typedPayload: T {
        return self._payload
    }

    public var meta: Encodable? {
        return self._meta
    }

    public var typedMeta: M? {
        return self._meta
    }

    public var schema: String {
        return _payload.schema
    }

    public init(from: T, meta: M?) {
        _payload = from
        _meta = meta
    }

    public func encode(to encoder: Encoder) throws {
        if let meta = _meta {
            try meta.encode(to: encoder)
        }
        try self._payload.encode(to: encoder)
    }

    public func toJson() throws -> String {
        return try PayloadBuilder.toJson(from: self)
    }
}

public class WithCustomMetaInstance<T: PayloadInstance, M: Codable>:
    EncodableWithCustomMetaInstance<T, M>, Decodable {

    override public init(from: T, meta: M?) {
        super.init(from: from, meta: meta)
    }

    public required init(from decoder: Decoder) throws {
        super.init(from: try T(from: decoder), meta: try M(from: decoder))
    }
}

public class WithMetaInstance<T: PayloadInstance>: WithCustomMetaInstance<T, EmptyMeta> {
    public init(from: T) {
        super.init(from: from, meta: nil)
    }

    public required init(from decoder: Decoder) throws {
        super.init(from: try T(from: decoder), meta: nil)
    }
}

public class PayloadBuilder {

    /// The data hash excludes both storage (`_`) and client (`$`) meta fields, at the top
    /// level only. This is the value that gets signed and referenced in `payload_hashes`.
    static public func dataHash<T: EncodablePayload>(from: T) throws -> Hash {
        let data = try JSONEncoder().encode(from)
        let canonical = try Canonicalizer.canonicalJson(from: data, exclusion: .allMeta)
        return try canonical.sha256()
    }

    /// The root hash keeps client (`$`) meta fields (e.g. `$signatures`) and strips only
    /// storage (`_`) meta, at the top level only.
    static public func hash<T: EncodableWithMeta>(fromWithMeta: T) throws -> Hash {
        let data = try JSONEncoder().encode(fromWithMeta)
        let canonical = try Canonicalizer.canonicalJson(from: data, exclusion: .storageMeta)
        return try canonical.sha256()
    }

    static public func hash<T: EncodablePayloadInstance, M: EncodableEmptyMeta>(from: T, meta: M?)
        throws -> Hash {
        let withMeta = EncodableWithCustomMetaInstance(from: from, meta: meta)
        return try hash(fromWithMeta: withMeta)
    }

    static public func hash<T: EncodablePayloadInstance>(from: T) throws -> Hash {
        let withMeta = EncodableWithMetaInstance(from: from)
        return try hash(fromWithMeta: withMeta)
    }

    static public func toJson<T: Encodable>(from: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(from)
        guard let result = String(data: data, encoding: .utf8) else {
            throw PayloadBuilderError.encodingError
        }
        return result
    }

    static public func toJsonWithMeta<T: EncodablePayloadInstance>(from: T, meta: (any Encodable)?)
        throws -> String {
        guard let m = meta else {
            return try PayloadBuilder.toJson(from: from)
        }
        let data = try mergeToJsonObject(from, m)
        guard let result = String(data: data, encoding: .utf8) else {
            throw PayloadBuilderError.encodingError
        }
        return result
    }
}
