import Alamofire
import Foundation
import XyoClient

/// HTTP JSON-RPC transport for an XL1 node, matching the Android `HttpRpcTransport`. POSTs a
/// JSON-RPC 2.0 request and returns the `result`, throwing on transport or RPC errors.
public final class HttpRpcTransport: RpcTransport {
    public let rpcUrl: String

    public init(rpcUrl: String) {
        self.rpcUrl = rpcUrl
    }

    @available(iOS 15, *)
    public func sendRawRequest(method: String, params: [JSONValue]) async throws -> JSONValue? {
        let request = JsonRpcRequest(id: UUID().uuidString, method: method, params: params)
        let data = try await AF.request(
            rpcUrl, method: .post, parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: ["Content-Type": "application/json"]
        )
        .validate()
        .serializingData()
        .value

        let response = try JSONDecoder().decode(JsonRpcResponse.self, from: data)
        if let error = response.error {
            throw RpcTransportError.rpcError(
                method: method, code: error.code, message: error.message)
        }
        return response.result
    }
}
