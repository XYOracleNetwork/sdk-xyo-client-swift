import CommonCrypto
import Foundation

public enum BoundWitnessBuilderError: Error {
  case encodingError
}

@available(iOS 13.0, *)
@available(OSX 10.15, *)

public class BoundWitnessBuilder {
  private var _addresses: [String] = []
  private var _previous_hashes: [String?] = []
  private var _payload_hashes: [String] = []
  private var _payload_schemas: [String] = []
  private var _payloads: [Codable] = []
  
  public func witness(_ address: String, _ previousHash: String? = nil) -> BoundWitnessBuilder {
    _addresses.append(address)
    _previous_hashes.append(previousHash)
    return self
  }
  
  private func hashableFields() -> XyoBoundWitnessBodyJson {
    return XyoBoundWitnessBodyJson(
      _addresses,
      _previous_hashes,
      _payload_hashes,
      _payload_schemas
    )
  }
  
  public func payload<T: Codable>(_ schema: String, _ payload: T) throws -> BoundWitnessBuilder {
    _payloads.append(payload)
    _payload_hashes.append(try BoundWitnessBuilder.hash(payload))
    _payload_schemas.append(schema)
    return self
  }
  
  public func build() throws -> XyoBoundWitnessJson {
    let bw = XyoBoundWitnessJson()
    let hashable = hashableFields()
    bw._hash = try BoundWitnessBuilder.hash(hashable)
    bw._client = "swift"
    bw._payloads = _payloads
    bw.addresses = _addresses
    bw.previous_hashes = _previous_hashes
    bw.payload_hashes = _payload_hashes
    bw.payload_schemas = _payload_schemas
    return bw
  }
  
  static func hash<T: Codable>(_ json: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    let data = try encoder.encode(json)
    
    guard let str = String(data: data, encoding: .utf8) else {
      throw BoundWitnessBuilderError.encodingError
    }
    return str.sha256()
  }
}
