import Foundation
import CommonCrypto

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

public extension String {
  func sha256() -> String{
    if let stringData = self.data(using: String.Encoding.utf8) {
      return stringData.sha256()
    }
    return ""
  }
}

@available(iOS 13.0, *)
@available(OSX 10.15, *)
class BoundWitnessBuilder {
  private var _addresses: [String] = []
  private var _previous_hashes: [String?] = []
  private var _payload_hashes: [String] = []
  private var _payload_schemas: [String] = []
  private var _payloads: [Codable] = []

  public func witness(_ address: String, _ previousHash: String? = nil) -> BoundWitnessBuilder {
    self._addresses.append(address)
    self._previous_hashes.append(previousHash)
    return self
  }
  
  public func hashableFields() -> XyoBoundWitnessBodyJson {
    return XyoBoundWitnessBodyJson (
      self._addresses,
      self._previous_hashes,
      self._payload_hashes,
      self._payload_schemas
    )
  }
  
  public func payload<T: Codable>(_ schema: String, _ payload: T) throws -> BoundWitnessBuilder {
    self._payloads.append(payload)
    self._payload_hashes.append(try BoundWitnessBuilder.hash(payload))
    self._payload_schemas.append(schema)
    return self
  }

  public func build() throws -> XyoBoundWitnessJson {
    let bw = XyoBoundWitnessJson()
    let hashable = self.hashableFields()
    bw._hash = try BoundWitnessBuilder.hash(hashable)
    bw._client = "swift"
    bw._payloads = self._payloads
    bw.addresses = self._addresses
    bw.previous_hashes = self._previous_hashes
    bw.payload_hashes = self._payload_hashes
    bw.payload_schemas = self._payload_schemas
    return bw
  }
  
  static func hash<T : Codable>(_ json: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    let data = try encoder.encode(json)
    let str = String(data: data, encoding: .utf8)!
    return str.sha256()
  }
}
