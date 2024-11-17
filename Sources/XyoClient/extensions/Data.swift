import CommonCrypto
import Foundation
import keccak

extension Data {
    var pointer: UnsafePointer<UInt8>! {
        return withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> UnsafePointer<UInt8>? in
            bytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
    }

    mutating func mutablePointer() -> UnsafeMutablePointer<UInt8>! {
        return withUnsafeMutableBytes {
            (bytes: UnsafeMutableRawBufferPointer) -> UnsafeMutablePointer<UInt8>? in
            bytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
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
        return Data.hexStringFromData(input: self as NSData).padding(
            toLength: expectedLength ?? self.count * 2, withPad: "0", startingAt: 0
        ).lowercased()
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

    static func dataFrom(hexString: String) -> Data? {
        var data = Data()
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Ensure the hex string has an even length
        guard hexString.count % 2 == 0 else {
            print("Invalid hex string length.")
            return nil
        }

        var index = hexString.startIndex
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            let byteString = hexString[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                print("Invalid hex character: \(byteString)")
                return nil
            }
            index = nextIndex
        }
        return data
    }

    /// - Returns: kaccak256 hash of data
    public func keccak256() -> Data {
        var data = Data(count: 32)
        keccak_256(data.mutablePointer(), 32, pointer, count)
        return data
    }
}
