import Foundation
import XyoClient

/// A JSON-RPC 2.0 request, matching the Android `JsonRpcRequest`.
public struct JsonRpcRequest: Encodable {
    public let jsonrpc: String
    public let id: String
    public let method: String
    public let params: [JSONValue]

    public init(id: String, method: String, params: [JSONValue] = []) {
        self.jsonrpc = "2.0"
        self.id = id
        self.method = method
        self.params = params
    }
}

/// A JSON-RPC 2.0 error object.
public struct JsonRpcError: Decodable, Error {
    public let code: Int
    public let message: String
    public let data: JSONValue?
}

/// A JSON-RPC 2.0 response, matching the Android `JsonRpcResponse`.
public struct JsonRpcResponse: Decodable {
    public let jsonrpc: String?
    public let id: String?
    public let result: JSONValue?
    public let error: JsonRpcError?

    public var isSuccess: Bool { error == nil }
    public var isError: Bool { error != nil }
}

/// Standard JSON-RPC error codes.
public enum JsonRpcErrorCodes {
    public static let parseError = -32700
    public static let invalidRequest = -32600
    public static let methodNotFound = -32601
    public static let invalidParams = -32602
    public static let internalError = -32603
}
