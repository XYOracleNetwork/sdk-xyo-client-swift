import Foundation

public enum PayloadBuilderError: Error {
    case encodingError
}

struct EmptyMeta: Encodable {}

class EncodableWithMeta<T: Encodable>: EncodableWithCustomMeta<T, EmptyMeta> {
    init(from: T) {
        super.init(from: from, meta: nil)
    }
}

class EncodableWithCustomMeta<T: Encodable, M: Encodable>: Encodable {
    private var _meta: M? = nil
    private var _payload: T

    enum CodingKeys: String, CodingKey {
        case _hash = "$hash"
        case _meta = "$meta"
    }
    
    init(from: T, meta: M?) {
        _payload = from
        _meta = meta
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let hash = try PayloadBuilder.dataHash(from: _payload).toHex()
        try container.encode(hash, forKey: ._hash)
        if (_meta != nil) {
            try container.encode(_meta, forKey: ._meta)
        }
        try self._payload.encode(to: encoder)
    }
    
    public func toJson() throws -> String {
        return try PayloadBuilder.toJson(from: self)
    }
}

class PayloadBuilder {
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
    
    // NOTE: Temporary fix until we have a custom JSON Serializer
    // this method currently has issues with round tripping of floating
    // point numbers as precision doesn't round trip
    static public func dataHash<T: Encodable>(from: T) throws -> Hash {

        let jsonString = try PayloadBuilder.toJson(from: from)
        return try jsonString.sha256()
    }
    
    // NOTE: Temporary fix until we have a custom JSON Serializer
    // this method currently has issues with round tripping of floating
    // point numbers as precision doesn't round trip
    static public func hash<T: Encodable>(from: T) throws -> Hash {
        let withMeta = EncodableWithMeta(from: from)
        let jsonString = try withMeta.toJson()
        return try jsonString.sha256()
    }
    
    static public func toJson<T: Encodable>(from: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(from)
        guard let result = String(data: data, encoding: .utf8) else { throw PayloadBuilderError.encodingError }
        return result
    }
    
    static public func toJsonWithMeta<T: Encodable, M: Encodable>(from: T, meta: M?) throws -> String {
        let target = EncodableWithCustomMeta(from: from, meta: meta)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(target)
        guard let result = String(data: data, encoding: .utf8) else { throw PayloadBuilderError.encodingError }
        return result
    }
}
