import CommonCrypto
import Foundation

public enum BoundWitnessBuilderError: Error {
  case encodingError
}

public class BoundWitnessBuilder {
  private var _witnesses: [AccountInstance] = []
  private var _previous_hashes: [String?] = []
  private var _payload_hashes: [String] = []
  private var _payload_schemas: [String] = []
  private var _payloads: [XyoPayload] = []

  public init() {
  }

  public func witness(_ address: XyoAddress, _ previousHash: String? = nil) -> BoundWitnessBuilder {
    _witnesses.append(address)
    _previous_hashes.append(previousHash)
    return self
  }

  public func witnesses(_ witnesses: [AbstractWitness]) -> BoundWitnessBuilder {
    _witnesses.append(contentsOf: witnesses.map { witness in witness.account })
    _previous_hashes.append(contentsOf: witnesses.map { witness in witness.previousHash })
    return self
  }

  private func hashableFields() -> XyoBoundWitnessBodyJson {
    return XyoBoundWitnessBodyJson(
      _witnesses.map { witness in witness.address },
      _previous_hashes,
      _payload_hashes,
      _payload_schemas
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

  public func sign(hash: String) throws -> [String?] {
    return try self._witnesses.map {
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
    bw.addresses = _witnesses.map { witness in witness.address }
    bw.previous_hashes = _previous_hashes
    bw.payload_hashes = _payload_hashes
    bw.payload_schemas = _payload_schemas
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
