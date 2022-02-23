import CommonCrypto
import Foundation
import keccak

extension Data {
    var pointer: UnsafePointer<UInt8>! { return withUnsafeBytes { $0 } }
    mutating func mutablePointer() -> UnsafeMutablePointer<UInt8>! {
        return withUnsafeMutableBytes { $0 }
    }
    
    func sha256() -> Data {
        return digest(input: self as NSData) as Data
    }
    
    func digest(input: NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    func toHex(_ expectedLength: Int? = nil) -> String {
        return Data.hexStringFromData(input: self as NSData).padding(toLength: expectedLength ?? self.count * 2, withPad: "0", startingAt: 0).lowercased()
    }
    
    static func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        
        return hexString
    }
    
    /// - Returns: kaccak256 hash of data
    public func keccak256() -> Data {
        var data = Data(count: 32)
        keccak_256(data.mutablePointer(), 32, pointer, count)
        return data
    }
}
