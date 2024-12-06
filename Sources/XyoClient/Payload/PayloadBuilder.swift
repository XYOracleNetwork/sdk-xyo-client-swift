import Foundation

public enum PayloadBuilderError: Error {
    case encodingError
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

public struct EncodableInstance: Encodable {
    public func encode(to encoder: Encoder) throws {
        fatalError("This method must be overridden in a subclass")
    }
}

public class EncodableEmptyMeta: Encodable {}

public class EmptyMeta: Codable {}

public class EncodableWithMetaInstance<T: EncodablePayload>: EncodableWithCustomMetaInstance<
    T, EncodableEmptyMeta
>
{
    public init(from: T) {
        super.init(from: from, meta: nil)
    }
}

public class EncodableWithCustomMetaInstance<T: EncodablePayload, M: Encodable>: EncodableWithMeta {
    var _meta: M? = nil
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

    enum CodingKeys: String, CodingKey {
        case _hash = "$hash"
        case _meta = "$meta"
    }

    public var schema: String {
        return _payload.schema
    }

    public init(from: T, meta: M?) {
        _payload = from
        _meta = meta
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let hash = try PayloadBuilder.dataHash(from: _payload).toHex()
        try container.encode(hash, forKey: ._hash)
        if _meta != nil {
            try container.encode(_meta, forKey: ._meta)
        }
        try self._payload.encode(to: encoder)
    }

    public func toJson() throws -> String {
        return try PayloadBuilder.toJson(from: self)
    }
}

public class WithCustomMetaInstance<T: PayloadInstance, M: Codable>:
    EncodableWithCustomMetaInstance<T, M>, Decodable
{

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
    private static func isHashableField(_ key: String) -> Bool {
        // Remove keys starting with "_"
        return !key.hasPrefix("_")
    }

    private static func isDataHashableField(_ key: String) -> Bool {
        // Remove keys starting with "_"
        return isHashableField(key)
            // Remove keys starting with "$"
            && !key.hasPrefix("$")
    }

    private static func dataHashableFields(_ jsonObject: Any) -> Any {
        if let dictionary = jsonObject as? [String: Any] {
            // Process dictionaries: filter keys, sort, and recurse
            let filteredDictionary =
                dictionary
                .filter { isDataHashableField($0.key) }  // Filter meta fields
                .sorted { $0.key < $1.key }  // Sort keys lexicographically
                .reduce(into: [String: Any]()) { result, pair in
                    result[pair.key] = dataHashableFields(pair.value)  // Recurse on values
                }
            return filteredDictionary
        } else if let array = jsonObject as? [Any] {
            // Process arrays: recursively process each element
            return array.map { dataHashableFields($0) }
        } else {
            // Return primitives (String, Number, etc.)
            return jsonObject
        }
    }

    private static func hashableFields(_ jsonObject: Any) -> Any {
        if let dictionary = jsonObject as? [String: Any] {
            // Process dictionaries: filter keys, sort, and recurse
            let filteredDictionary =
                dictionary
                .sorted { $0.key < $1.key }  // Sort keys lexicographically
                .reduce(into: [String: Any]()) { result, pair in
                    result[pair.key] = hashableFields(pair.value)  // Recurse on values
                }
            return filteredDictionary
        } else if let array = jsonObject as? [Any] {
            // Process arrays: recursively process each element
            return array.map { dataHashableFields($0) }
        } else {
            // Return primitives (String, Number, etc.)
            return jsonObject
        }
    }

    static public func dataHash<T: EncodablePayload>(from: T) throws -> Hash {
        let jsonString = try PayloadBuilder.toJson(from: from)
        return try jsonString.sha256()
    }

    static public func hash<T: EncodableWithMeta>(fromWithMeta: T) throws -> Hash {
        let jsonString = try fromWithMeta.toJson()
        return try jsonString.sha256()
    }

    static public func hash<T: EncodablePayloadInstance, M: EncodableEmptyMeta>(from: T, meta: M)
        throws -> Hash
    {
        let withMeta = EncodableWithCustomMetaInstance(from: from, meta: meta)
        let jsonString = try withMeta.toJson()
        return try jsonString.sha256()
    }

    static public func hash<T: EncodablePayloadInstance>(from: T) throws -> Hash {
        let withMeta = EncodableWithMetaInstance(from: from)
        let jsonString = try withMeta.toJson()
        return try jsonString.sha256()
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

    static public func toJsonWithMeta<T: EncodablePayloadInstance, M: Encodable>(from: T, meta: M?)
        throws -> String
    {
        let target = EncodableWithCustomMetaInstance(from: from, meta: meta)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(target)
        guard let result = String(data: data, encoding: .utf8) else {
            throw PayloadBuilderError.encodingError
        }
        return result
    }
}
