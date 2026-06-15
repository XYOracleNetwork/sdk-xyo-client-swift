import Foundation
import XyoClient

/// Aggregate facade over the XL1 chain views/runners, matching the Android `XyoViewer`. Composes
/// the high-value viewers/runner over a single transport and exposes a generic `call` for any
/// RPC method (every method in `RpcMethodNames` is reachable this way).
@available(iOS 15, *)
public final class XyoViewer {
    public let transport: RpcTransport
    public let block: BlockViewer
    public let transaction: TransactionViewer
    public let accountBalance: AccountBalanceViewer
    public let mempool: MempoolViewer
    public let mempoolRunner: MempoolRunner

    public init(transport: RpcTransport) {
        self.transport = transport
        self.block = BlockViewer(transport: transport)
        self.transaction = TransactionViewer(transport: transport)
        self.accountBalance = AccountBalanceViewer(transport: transport)
        self.mempool = MempoolViewer(transport: transport)
        self.mempoolRunner = MempoolRunner(transport: transport)
    }

    public convenience init(rpcUrl: String) {
        self.init(transport: HttpRpcTransport(rpcUrl: rpcUrl))
    }

    /// Call any RPC method, returning the raw decoded result.
    public func call(method: String, params: [JSONValue] = []) async throws -> JSONValue? {
        try await transport.sendRequest(method: method, params: params)
    }

    /// Call any RPC method, decoding the result into a concrete `Decodable` type.
    public func call<T: Decodable>(
        method: String, params: [JSONValue] = [], as type: T.Type = T.self
    ) async throws -> T {
        try await transport.sendRequest(method: method, params: params, as: type)
    }

    // Convenience pass-throughs for the most common reads.
    public func currentBlock() async throws -> JSONValue? { try await block.currentBlock() }
    public func transactionByHash(_ hash: String) async throws -> JSONValue? {
        try await transaction.transactionByHash(hash)
    }
    public func accountBalances(_ addresses: [String]) async throws -> JSONValue? {
        try await accountBalance.qualifiedAccountBalances(addresses: addresses)
    }
    public func pendingTransactions() async throws -> JSONValue? {
        try await mempool.pendingTransactions()
    }
}
