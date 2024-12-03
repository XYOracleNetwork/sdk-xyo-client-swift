import Foundation
import CryptoKit
import CryptoSwift
import BigInt

public enum Bip39Error: Error {
    case invalidSeedLength
    case invalidSeedChecksum
    case invalidMnemonicLength
    case invalidMnemonicChecksum
    case invalidMnemonicWordCount
    case invalidMnemonicWordIndex
    case invalidMnemonicWord
    case failedToGenerateSeed
    case invalidByteCode
    case failedToEncode
    case invalidEntropyLength
    case invalidPrivateKeyGenerated
    case failedToComputeHmac
    case invalidCurveOrder
    case invalidKey
}

struct HMACSHA512ByteRange {
    static let left = ..<32
    static let right = 32...

    private init() {}
}

public class Bip39 {
    static let wordList: [String] = Bip39Words
    
    static func mnemonicToSeed(phrase: String) throws -> Data {
        let entropy = try mnemonicToEntropy(phrase: phrase)
        return try entropyToSeed(entropy: entropy)
    }

    /// Helper: Calculate checksum for the seed
    private static func calculateChecksum(entropy: Data, bits: Int) -> String {
        let hash = SHA256.hash(data: entropy)
        let hashBits = hash.map { String($0, radix: 2).leftPad(toLength: 8, with: "0") }.joined()
        return String(hashBits.prefix(bits))
    }

    /// Helper: Convert seed (entropy) to a binary string
    private static func seedToBits(_ seed: Data) -> String {
        return seed.map { String($0, radix: 2).leftPad(toLength: 8, with: "0") }.joined()
    }
    
    static func generateEntropy(bits: Int) -> Data {
        precondition(bits % 32 == 0, "Entropy must be a multiple of 32")
        let byteCount = bits / 8
        var entropy = Data(count: byteCount)
        _ = entropy.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, byteCount, bytes.baseAddress!)
        }
        return entropy
    }
    
    static func mnemonicToEntropy(phrase: String) throws -> Data {
        let words = phrase.lowercased().split(separator: " ").map(String.init)

        // Step 1: Validate word count
        guard [12, 15, 18, 21, 24].contains(words.count) else {
            throw Bip39Error.invalidMnemonicWordCount
        }

        // Step 2: Map words to indices
        let indices = words.compactMap { wordList.firstIndex(of: $0) }
        guard indices.count == words.count else {
            throw Bip39Error.invalidMnemonicWordCount
        }

        // Step 3: Reconstruct combined bits from indices
        let combinedBits = indices
            .map { String($0, radix: 2).leftPad(toLength: 11, with: "0") }
            .joined()

        // Step 4: Separate entropy and checksum
        let checksumBits = words.count / 3
        let entropyBits = combinedBits.count - checksumBits

        let entropyBinary = String(combinedBits.prefix(entropyBits))
        let checksumBinary = String(combinedBits.suffix(checksumBits))

        // Step 5: Convert binary entropy to Data
        let entropy = try binaryStringToData(entropyBinary)

        // Step 6: Verify checksum
        let calculatedChecksum = calculateChecksum(entropy: entropy, bits: checksumBits)
        guard checksumBinary == calculatedChecksum else {
            throw Bip39Error.invalidMnemonicChecksum
        }

        return entropy
    }
    
    static func entropyToMnemonic(entropy: Data) throws -> String {
        // Step 1: Validate entropy length
        guard [16, 20, 24, 28, 32].contains(entropy.count) else {
            throw Bip39Error.invalidEntropyLength
        }

        // Step 2: Calculate checksum
        let checksumBits = entropy.count * 8 / 32
        let checksum = calculateChecksum(entropy: entropy, bits: checksumBits)

        // Step 3: Combine entropy and checksum into a binary string
        let entropyBits = entropy.map { String($0, radix: 2).leftPad(toLength: 8, with: "0") }.joined()
        let combinedBits = entropyBits + checksum

        // Step 4: Split combined bits into 11-bit chunks
        let chunks = stride(from: 0, to: combinedBits.count, by: 11).map { startIndex in
            let start = combinedBits.index(combinedBits.startIndex, offsetBy: startIndex)
            let end = combinedBits.index(start, offsetBy: 11)
            return String(combinedBits[start..<end])
        }

        // Step 5: Map 11-bit chunks to words in the word list
        let mnemonicWords = chunks.compactMap { chunk in
            if let index = Int(chunk, radix: 2), index < wordList.count {
                return wordList[index]
            }
            return nil
        }

        // Ensure all chunks were converted to words
        guard mnemonicWords.count == chunks.count else {
            throw Bip39Error.invalidMnemonicLength
        }

        return mnemonicWords.joined(separator: " ")
    }
    
    static func entropyToSeed(entropy: Data, passphrase: String = "") throws -> Data {
        // Step 1: Convert entropy to mnemonic
        let mnemonic = try entropyToMnemonic(entropy: entropy)
        // Step 2: Apply PBKDF2 to derive the seed
        let salt = "mnemonic" + passphrase
        guard let mnemonicData = mnemonic.data(using: .utf8),
              let saltData = salt.data(using: .utf8) else {
            throw Bip39Error.failedToEncode
        }

        do {
            let seed = try PKCS5.PBKDF2(
                password: Array(mnemonicData),
                salt: Array(saltData),
                iterations: 2048,
                keyLength: 64,
                variant: .sha2(.sha512)
            ).calculate()

            return Data(seed)
        } catch {
            throw Bip39Error.failedToGenerateSeed
        }
    }
    
    static func rootPrivateKeyFromSeed(seed: Data) throws -> Key {
        
        let hmacSHA512Key = "Bitcoin seed"
        let keyLength = 32
        let keyPrefix = Data.dataFrom(hexString: "00")!
        
        let hmacSHA512 = HMAC(key: hmacSHA512Key.bytes, variant: .sha2(.sha512))
        do {
            let hmacSHA512Bytes = try hmacSHA512.authenticate(seed.bytes)
            let key = Data(hmacSHA512Bytes[HMACSHA512ByteRange.left])
            let chainCode = Data(hmacSHA512Bytes[HMACSHA512ByteRange.right])

            let bigIntegerKey = BigUInt(key)
            guard !bigIntegerKey.isZero, bigIntegerKey < .secp256k1CurveOrder else {
                throw Bip39Error.invalidKey
            }
            let serializedBigIntegerKey = bigIntegerKey.serialize()
            let privatekey = serializedBigIntegerKey.count == keyLength
                ? serializedBigIntegerKey
                : keyPrefix.bytes + serializedBigIntegerKey

            return Key(privateKey: privatekey, chainCode: chainCode)
        } catch {
            throw Bip39Error.invalidKey
        }
    }

    private static func isValidPrivateKey(privateKey: Data) throws -> Bool {
        // Ensure private key is exactly 32 bytes
        guard privateKey.count == 32 else {
            print("Invalid private key length: must be 32 bytes.")
            return false
        }

        // secp256k1 curve order (maximum valid private key value)
        let curveOrderHex = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"
        guard let curveOrder = BigUInt(curveOrderHex, radix: 16) else { throw Bip39Error.invalidCurveOrder }

        // Convert private key to BigUInt
        let privateKeyValue = BigUInt(privateKey)

        // Check if private key is within the valid range (0 < key < curve order)
        if privateKeyValue > 0 && privateKeyValue < curveOrder {
            return true
        } else {
            print("Private key is out of valid range.")
            return false
        }
    }

    private static func binaryStringToData(_ binary: String) throws -> Data {
        var data = Data()
        for i in stride(from: 0, to: binary.count, by: 8) {
            let startIndex = binary.index(binary.startIndex, offsetBy: i)
            let endIndex = binary.index(startIndex, offsetBy: min(8, binary.count - i))
            let byteString = binary[startIndex..<endIndex]
            if let byte = UInt8(byteString, radix: 2) {
                data.append(byte)
            } else {
                throw Bip39Error.invalidByteCode
            }
        }
        return data
    }
}

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
}

extension BigUInt {
    static let secp256k1CurveOrder = BigUInt(
        "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
        radix: 16
    )!
}
