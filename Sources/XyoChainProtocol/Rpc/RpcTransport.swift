import Foundation
import XyoClient

/// Identifies a chain RPC provider, matching the Android `Provider`.
public protocol Provider {
    var moniker: String { get }
}

public enum RpcTransportError: Error {
    case emptyResponse(method: String)
    case rpcError(method: String, code: Int, message: String)
    case decodingFailure(method: String)
}

/// Transport for issuing JSON-RPC requests to an XL1 node.
public protocol RpcTransport {
    /// Send an RPC request and return the raw `result` value.
    @available(iOS 15, *)
    func sendRawRequest(method: String, params: [JSONValue]) async throws -> JSONValue?
}

extension RpcTransport {
    /// Send a typed RPC request, decoding the `result` into `T` via `Codable`.
    @available(iOS 15, *)
    public func sendRequest<T: Decodable>(
        method: String, params: [JSONValue] = [], as type: T.Type = T.self
    ) async throws -> T {
        let raw = try await sendRawRequest(method: method, params: params)
        let result = raw ?? .null
        let data = try JSONEncoder().encode(result)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RpcTransportError.decodingFailure(method: method)
        }
    }

    /// Send an RPC request and return the raw decoded `JSONValue` result.
    @available(iOS 15, *)
    public func sendRequest(method: String, params: [JSONValue] = []) async throws -> JSONValue? {
        try await sendRawRequest(method: method, params: params)
    }
}
