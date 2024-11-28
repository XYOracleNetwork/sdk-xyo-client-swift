import CommonCrypto
import Foundation

public enum BoundWitnessBuilderError: Error {
    case encodingError
}

public class BoundWitnessBuilder {
    private var _accounts: [AccountInstance] = []
    private var _previous_hashes: [Hash?] = []
    private var _payload_hashes: [Hash] = []
    private var _payload_schemas: [String] = []
    private var _payloads: [EncodablePayload] = []
    private var _query: Hash? = nil

    public init() {
    }

    public func signer(_ account: AccountInstance)
        -> BoundWitnessBuilder
    {
        _accounts.append(account)
        _previous_hashes.append(account.previousHash)
        return self
    }

    public func signers(_ accounts: [AccountInstance]) -> BoundWitnessBuilder {
        _accounts.append(contentsOf: accounts)
        _previous_hashes.append(contentsOf: accounts.map { account in account.previousHash })
        return self
    }

    public func payload<T: EncodablePayload>(_ schema: String, _ payload: T) throws -> BoundWitnessBuilder {
        _payloads.append(payload)
        _payload_hashes.append(try payload.hash())
        _payload_schemas.append(schema)
        return self
    }

    public func payloads(_ payloads: [EncodablePayload]) throws -> BoundWitnessBuilder {
        _payloads.append(contentsOf: payloads)
        _payload_hashes.append(
            contentsOf: try payloads.map { payload in try payload.hash() })
        _payload_schemas.append(contentsOf: payloads.map { payload in payload.schema })
        return self
    }

    public func query(_ payload: EncodablePayload) throws -> BoundWitnessBuilder {
        self._query = try payload.hash()
        let _ = try self.payload(payload.schema, payload)
        return self
    }

    public func sign(hash: Hash) throws -> [Signature] {
        return try self._accounts.map {
            try $0.sign(hash)
        }
    }

    public func build() throws -> (BoundWitnessWithMeta, [EncodablePayload]) {
        let bw = BoundWitness()
        bw.addresses = _accounts.map { account in account.address!.toHex() }
        bw.previous_hashes = _previous_hashes.map { hash in hash?.toHex()}
        bw.payload_hashes = _payload_hashes.map { hash in hash.toHex() }
        bw.payload_schemas = _payload_schemas
        if _query != nil {
            bw.query = _query?.toHex()
        }
        let signatures = try self.sign(hash: bw.dataHash()).map {signature in signature.toHex()}
        let meta = BoundWitnessMeta(signatures)
        let bwWithMeta = BoundWitnessWithMeta(boundWitness: bw, meta: meta)
        return (bwWithMeta, _payloads)
    }
}
