import Foundation
import XyoClient

public enum TransactionBuilderError: Error {
    case missingChain
    case missingFees
    case missingRange
    case missingFrom
}

/// Builds and signs an XL1 transaction bound witness, matching the Android `TransactionBuilder`
/// and the authoritative JS `buildTransaction`. The signable form excludes `$signatures` and uses
/// `0x`-stripped fees; signers sign its data hash.
public final class TransactionBuilder {
    private var _chain: ChainId?
    private var _fees: TransactionFeesBigInt?
    private var _nbf: XL1BlockNumber?
    private var _exp: XL1BlockNumber?
    private var _payloads: [EncodablePayloadInstance] = []
    private var _signers: [AccountInstance] = []
    private var _from: String?
    private var _scripts: [String] = []

    public init() {}

    @discardableResult public func chain(_ chain: ChainId) -> TransactionBuilder {
        _chain = chain
        return self
    }
    @discardableResult public func fees(_ fees: TransactionFeesBigInt) -> TransactionBuilder {
        _fees = fees
        return self
    }
    @discardableResult public func range(nbf: XL1BlockNumber, exp: XL1BlockNumber) -> TransactionBuilder {
        _nbf = nbf
        _exp = exp
        return self
    }
    @discardableResult public func range(nbf: Int64, exp: Int64) -> TransactionBuilder {
        _nbf = XL1BlockNumber(nbf)
        _exp = XL1BlockNumber(exp)
        return self
    }
    @discardableResult public func payload(_ payload: EncodablePayloadInstance) -> TransactionBuilder {
        _payloads.append(payload)
        return self
    }
    @discardableResult public func payloads(_ payloads: [EncodablePayloadInstance]) -> TransactionBuilder {
        _payloads.append(contentsOf: payloads)
        return self
    }
    @discardableResult public func from(_ address: String) -> TransactionBuilder {
        _from = address
        return self
    }
    @discardableResult public func signer(_ signer: AccountInstance) -> TransactionBuilder {
        _signers.append(signer)
        return self
    }
    @discardableResult public func signers(_ signers: [AccountInstance]) -> TransactionBuilder {
        _signers.append(contentsOf: signers)
        return self
    }
    @discardableResult public func script(_ script: String) -> TransactionBuilder {
        _scripts.append(script)
        return self
    }

    public func build() throws -> HydratedTransaction {
        guard let chain = _chain else { throw TransactionBuilderError.missingChain }
        guard let fees = _fees else { throw TransactionBuilderError.missingFees }
        guard let nbf = _nbf, let exp = _exp else { throw TransactionBuilderError.missingRange }
        guard let from = _from ?? _signers.first?.address?.toHex() else {
            throw TransactionBuilderError.missingFrom
        }

        let payloadHashes = try _payloads.map { try PayloadBuilder.dataHash(from: $0).toHex() }
        let autoScript = payloadHashes.map { "elevate|\($0)" }

        // Combine explicit scripts with the auto-generated elevate scripts, preserving order
        // and removing duplicates (matches Kotlin's `(scripts + autoScript).distinct()`).
        var seen = Set<String>()
        let combined = (_scripts + autoScript).filter { seen.insert($0).inserted }
        let script: [String]? = combined.isEmpty ? nil : combined

        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let addresses = _signers.map { $0.address?.toHex() ?? "" }
        let previousHashes = _signers.map { $0.previousHash?.toHex() }
        let payloadSchemas = _payloads.map { $0.schema }
        let normalizedFees = fees.toHex().normalized()

        let signable = SignableTransactionBoundWitness(
            from: from, chain: chain, nbf: nbf.value, exp: exp.value, fees: normalizedFees,
            script: script, addresses: addresses, payload_hashes: payloadHashes,
            payload_schemas: payloadSchemas, previous_hashes: previousHashes, timestamp: timestamp)

        let dataHash = try PayloadBuilder.dataHash(from: signable)
        let signatures = try _signers.map { try $0.sign(dataHash).toHex() }

        let boundWitness = TransactionBoundWitness(
            from: from, chain: chain, nbf: nbf.value, exp: exp.value, fees: normalizedFees,
            script: script, addresses: addresses, payload_hashes: payloadHashes,
            payload_schemas: payloadSchemas, previous_hashes: previousHashes,
            schema: TransactionBoundWitness.schema, timestamp: timestamp, signatures: signatures)

        return HydratedTransaction(boundWitness: boundWitness, payloads: _payloads)
    }
}
