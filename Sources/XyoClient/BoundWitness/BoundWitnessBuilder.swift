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
        let signatures = try self.sign(hash: bw.hash()).map {signature in signature.toHex()}
        let meta = BoundWitnessMeta(signatures)
        let bwWithMeta = BoundWitnessWithMeta(boundWitness: bw, meta: meta)
        return (bwWithMeta, _payloads)
    }

    private static func isDataField(_ key: String) -> Bool {
        // Remove keys starting with "_"
        return !key.hasPrefix("_")
            // Remove keys starting with "$"
            && !key.hasPrefix("$")
    }

    private static func dataHashableFields(_ jsonObject: Any) -> Any {
        if let dictionary = jsonObject as? [String: Any] {
            // Process dictionaries: filter keys, sort, and recurse
            let filteredDictionary =
                dictionary
                .filter { isDataField($0.key) }  // Filter meta fields
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

    static func hash<T: Encodable>(_ json: T) throws -> Hash {
        if let bw = json as? BoundWitness {
            return try hashWithoutUnderscores(bw)
        } else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys

            // Encode the object to JSON data
            let data = try encoder.encode(json)
            return data.sha256()
        }
    }

    // NOTE: Temporary fix until we have a custom JSON Serializer
    // this method currently has issues with round tripping of floating
    // point numbers as precision doesn't round trip
    static private func hashWithoutUnderscores<T: Encodable>(_ json: T) throws -> Hash {

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        // Encode the object to JSON data
        let data = try encoder.encode(json)

        // Decode the JSON into a dictionary, array, or primitive
        guard
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                as? [String: Any]
        else {
            throw BoundWitnessBuilderError.encodingError
        }

        // Recursively filter keys that are data hashable
        let filteredJSON = dataHashableFields(jsonObject)

        // Encode the filtered JSON back to data
        let filteredData = try JSONSerialization.data(
            withJSONObject: filteredJSON,
            options: [.sortedKeys]
        )
        // Hash the JSON string
        return filteredData.sha256()
    }
}
