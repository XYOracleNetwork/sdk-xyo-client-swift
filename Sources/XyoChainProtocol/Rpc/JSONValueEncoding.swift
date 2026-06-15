import Foundation
import XyoClient

/// Bridges any `Encodable` value into a `JSONValue` for use as RPC params.
public func toJSONValue<T: Encodable>(_ value: T) throws -> JSONValue {
    let data = try JSONEncoder().encode(value)
    return try JSONDecoder().decode(JSONValue.self, from: data)
}
