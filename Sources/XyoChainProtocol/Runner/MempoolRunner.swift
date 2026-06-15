import Foundation
import XyoClient

/// Submits transactions/blocks to the XL1 mempool over JSON-RPC, mirroring the Android
/// `MempoolRunner`. Requires a live XL1 RPC endpoint.
@available(iOS 15, *)
public final class MempoolRunner: Provider {
    public let moniker = "MempoolRunner"
    private let transport: RpcTransport

    public init(transport: RpcTransport) {
        self.transport = transport
    }

    /// Submit signed transactions as `[boundWitness, payloads]` tuples.
    public func submitTransactions(_ transactions: [HydratedTransaction]) async throws -> JSONValue? {
        let tuples: [JSONValue] = try transactions.map { transaction in
            let bw = try toJSONValue(transaction.boundWitness)
            let payloads = JSONValue.array(try transaction.payloads.map { payload in
                let data = try JSONEncoder().encode(payload)
                return try JSONDecoder().decode(JSONValue.self, from: data)
            })
            return .array([bw, payloads])
        }
        return try await transport.sendRequest(
            method: RpcMethodNames.mempoolRunnerSubmitTransactions, params: [.array(tuples)])
    }

    /// Submit raw transaction params directly (escape hatch for shapes not covered above).
    public func submitTransactions(rawParams: [JSONValue]) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.mempoolRunnerSubmitTransactions, params: rawParams)
    }
}
