import BigInt
import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    func leftPad(toLength: Int, with padCharacter: Character) -> String {
        let paddingCount = toLength - count
        guard paddingCount > 0 else { return self }
        return String(repeating: padCharacter, count: paddingCount) + self
    }
    func binaryToData() throws -> Data {
        var data = Data()
        for i in stride(from: 0, to: self.count, by: 8) {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex = self.index(startIndex, offsetBy: min(8, self.count - i))
            let byteString = self[startIndex..<endIndex]
            if let byte = UInt8(byteString, radix: 2) {
                data.append(byte)
            } else {
                throw Bip39Error.invalidByteCode
            }
        }
        return data
    }
}

extension Data {
    func toBigInt() -> BigInt {
        return BigInt(self)
    }
    func toBigUInt() -> BigUInt {
        return BigUInt(self)
    }
    func toBinaryString() -> String {
        return self.map { String($0, radix: 2).leftPad(toLength: 8, with: "0") }.joined()
    }
}

extension BigInt {
    /// Converts the BigInt to a Data representation.
    ///
    /// - Parameter length: The desired byte length of the output. Pads with leading zeros if necessary.
    ///                     If `nil`, the result is the minimal byte representation.
    /// - Returns: A `Data` object representing the BigInt.
    func toData(length: Int? = nil) -> Data {
        var magnitudeBytes = self.magnitude.serialize()

        // Adjust for desired length, if specified
        if let length = length {
            if magnitudeBytes.count < length {
                // Pad with leading zeros
                let padding = [UInt8](repeating: 0, count: length - magnitudeBytes.count)
                magnitudeBytes = padding + magnitudeBytes
            } else if magnitudeBytes.count > length {
                // Truncate to the specified length
                magnitudeBytes = magnitudeBytes.suffix(length)
            }
        }

        return Data(magnitudeBytes)
    }
}
