import Foundation
import XyoClient

/// XL1 chain read views over a JSON-RPC transport. Each mirrors the corresponding Android
/// `*Viewer`. Complex result shapes are returned as decoded `JSONValue` (callers decode into
/// concrete types); typed model wrappers can be layered on as needed. Network calls require a
/// live XL1 RPC endpoint.

@available(iOS 15, *)
public final class BlockViewer: Provider {
    public let moniker = "BlockViewer"
    private let transport: RpcTransport
    public init(transport: RpcTransport) { self.transport = transport }

    public func currentBlock() async throws -> JSONValue? {
        try await transport.sendRequest(method: RpcMethodNames.blockViewerCurrentBlock)
    }
    public func blocksByHash(_ hashes: [String]) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.blockViewerBlocksByHash,
            params: [.array(hashes.map { .string($0) })])
    }
    public func blocksByNumber(_ numbers: [Int]) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.blockViewerBlocksByNumber,
            params: [.array(numbers.map { .int($0) })])
    }
    public func payloadsByHash(_ hashes: [String]) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.blockViewerPayloadsByHash,
            params: [.array(hashes.map { .string($0) })])
    }
}

@available(iOS 15, *)
public final class TransactionViewer: Provider {
    public let moniker = "TransactionViewer"
    private let transport: RpcTransport
    public init(transport: RpcTransport) { self.transport = transport }

    public func byHash(_ hash: String) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.txViewerByHash, params: [.string(hash)])
    }
    public func transactionByHash(_ hash: String) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.txViewerTransactionByHash, params: [.string(hash)])
    }
}

@available(iOS 15, *)
public final class AccountBalanceViewer: Provider {
    public let moniker = "AccountBalanceViewer"
    private let transport: RpcTransport
    public init(transport: RpcTransport) { self.transport = transport }

    public func qualifiedAccountBalances(
        addresses: [String], config: JSONValue = .object([:])
    ) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.accountBalanceViewerQualifiedBalances,
            params: [.array(addresses.map { .string($0) }), config])
    }
    public func qualifiedAccountBalanceHistories(
        addresses: [String], config: JSONValue = .object([:])
    ) async throws -> JSONValue? {
        try await transport.sendRequest(
            method: RpcMethodNames.accountBalanceViewerQualifiedHistories,
            params: [.array(addresses.map { .string($0) }), config])
    }
}

@available(iOS 15, *)
public final class MempoolViewer: Provider {
    public let moniker = "MempoolViewer"
    private let transport: RpcTransport
    public init(transport: RpcTransport) { self.transport = transport }

    public func pendingTransactions() async throws -> JSONValue? {
        try await transport.sendRequest(method: RpcMethodNames.mempoolViewerPendingTransactions)
    }
    public func pendingBlocks() async throws -> JSONValue? {
        try await transport.sendRequest(method: RpcMethodNames.mempoolViewerPendingBlocks)
    }
}
