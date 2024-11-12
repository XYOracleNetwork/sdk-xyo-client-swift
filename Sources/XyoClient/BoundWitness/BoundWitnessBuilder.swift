import CommonCrypto
import Foundation

public enum BoundWitnessBuilderError: Error {
  case encodingError
}

public class BoundWitnessBuilder {
  private var _accounts: [AccountInstance] = []
  private var _previous_hashes: [String?] = []
  private var _payload_hashes: [String] = []
  private var _payload_schemas: [String] = []
  private var _payloads: [XyoPayload] = []
  private var _query: String? = nil

  public init() {
  }

  public func signer(_ account: AccountInstance, _ previousHash: String? = nil)
    -> BoundWitnessBuilder
  {
    _accounts.append(account)
    _previous_hashes.append(previousHash)
    return self
  }

  public func signers(_ accounts: [AccountInstance]) -> BoundWitnessBuilder {
    _accounts.append(contentsOf: accounts)
    _previous_hashes.append(contentsOf: accounts.map { account in account.previousHash })
    return self
  }

  private func hashableFields() -> XyoBoundWitnessBodyJson {
    return XyoBoundWitnessBodyJson(
      _accounts.map { witness in witness.address },
      _previous_hashes,
      _payload_hashes,
      _payload_schemas,
      _query
    )
  }

  public func payload<T: XyoPayload>(_ schema: String, _ payload: T) throws -> BoundWitnessBuilder {
    _payloads.append(payload)
    _payload_hashes.append(try payload.hash().toHex())
    _payload_schemas.append(schema)
    return self
  }

  public func payloads(_ payloads: [XyoPayload]) throws -> BoundWitnessBuilder {
    _payloads.append(contentsOf: payloads)
    _payload_hashes.append(contentsOf: try payloads.map { payload in try payload.hash().toHex() })
    _payload_schemas.append(contentsOf: payloads.map { payload in payload.schema })
    return self
  }

  public func query(_ payload: XyoPayload) throws -> BoundWitnessBuilder {
    self._query = try payload.hash().toHex()
    let _ = try self.payload(payload.schema, payload)
    return self
  }

  public func sign(hash: String) throws -> [String?] {
    return try self._accounts.map {
      try $0.sign(hash: hash)
    }
  }

  public func build(_ previousHash: String? = nil) throws -> (XyoBoundWitnessJson, [XyoPayload]) {
    let bw = XyoBoundWitnessJson()
    let hashable = hashableFields()
    let hash = try BoundWitnessBuilder.hash(hashable)
    bw._signatures = try self.sign(hash: hash)
    bw._hash = hash
    bw._client = "swift"
    bw._previous_hash = previousHash
    bw.addresses = _accounts.map { witness in witness.address }
    bw.previous_hashes = _previous_hashes
    bw.payload_hashes = _payload_hashes
    bw.payload_schemas = _payload_schemas
    if _query != nil {
      bw.query = _query
    }
    return (bw, _payloads)
  }

  static func hash<T: Encodable>(_ json: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    let data = try encoder.encode(json)

    guard let str = String(data: data, encoding: .utf8) else {
      throw BoundWitnessBuilderError.encodingError
    }
    return try str.sha256().toHex()
  }
}
