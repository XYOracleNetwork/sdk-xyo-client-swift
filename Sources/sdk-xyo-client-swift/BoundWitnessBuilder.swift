import Foundation
import SwiftyJSON
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
  private var body = XyoBoundWitnessBodyJson(fromJson: JSON([]))
  private var meta = XyoBoundWitnessMetaJson(fromJson: JSON([]))

  public func witness(_ address: String, _ previousHash: String? = nil) -> BoundWitnessBuilder {
    self.body.addresses.append(address)
    self.body.hashes.append(previousHash)
    return self
  }
  
  public func payload(_ payload: JSON) -> BoundWitnessBuilder {
    self.body.payload = payload
    return self
  }
  
  public func hashable() -> JSON {
    let bodyDictionary = self.body.toDictionary()
    let bodyJson = JSON(bodyDictionary)
    return bodyJson
  }

  public func build() -> JSON {
    let metaDictionary = self.meta.toDictionary()
    let bodyDictionary = self.body.toDictionary()
    self.meta._hash = BoundWitnessBuilder.hash(self.hashable())
    return JSON(bodyDictionary.merging(metaDictionary) { (_, new) in new })
  }

  static func sortObject(_ obj: JSON) -> JSON {
    return obj
  }

  static func hash(_ json: JSON) -> String {
    let str = json.rawString(.utf8, options: [.sortedKeys])!.replacingOccurrences(of: "\\\"", with: "\"")
    print(str)
    return str.sha256()
  }
}
