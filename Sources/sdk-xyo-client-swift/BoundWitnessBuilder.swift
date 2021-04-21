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
class BoundWitnessBuilder<T: Codable> {
  private var json = XyoBoundWitnessJson<T>()

  public func witness(_ address: String, _ previousHash: String? = nil) -> BoundWitnessBuilder {
    self.json.addresses.append(address)
    self.json.hashes.append(previousHash)
    return self
  }
  
  public func payload(_ payload: T) -> BoundWitnessBuilder {
    self.json.payload = payload
    return self
  }
  
  public func hashable() -> XyoBoundWitnessBodyJson<T> {
    return self.json as XyoBoundWitnessBodyJson
  }

  public func build() throws -> XyoBoundWitnessJson<T> {
    let hash = try BoundWitnessBuilder.hash(self.hashable())
    self.json._hash = hash
    return self.json
  }

  static func hash(_ json: XyoBoundWitnessBodyJson<T>) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    let data = try encoder.encode(json)
    let str = String(data: data, encoding: .utf8)!
    debugPrint("AAAAARRRRRIIIIIEEEEEE: \(str)")
    return str.sha256()
  }
}
