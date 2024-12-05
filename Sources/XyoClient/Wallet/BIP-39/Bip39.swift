import BigInt
import CryptoKit
import CryptoSwift
import Foundation

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

let BITCOIN_SEED = "Bitcoin seed".data(using: .utf8)!
let PRIVATE_KEY_SIZE = 32
let CHAINCODE_SIZE = 32

public class Bip39 {
    static let wordList: [String] = Bip39Words

    static func mnemonicToSeed(phrase: String) throws -> Data {
        let entropy = try mnemonicToEntropy(phrase: phrase)
        return try entropyToSeed(entropy: entropy)
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
        let combinedBits =
            indices
            .map { String($0, radix: 2).leftPad(toLength: 11, with: "0") }
            .joined()

        // Step 4: Separate entropy and checksum
        let checksumBits = words.count / 3
        let entropyBits = combinedBits.count - checksumBits

        let entropyBinary = String(combinedBits.prefix(entropyBits))
        let checksumBinary = String(combinedBits.suffix(checksumBits))

        // Step 5: Convert binary entropy to Data
        let entropy = try entropyBinary.binaryToData()

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
        let entropyBits = entropy.map { String($0, radix: 2).leftPad(toLength: 8, with: "0") }
            .joined()
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
            let saltData = salt.data(using: .utf8)
        else {
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

        let hmac = Hmac.hmacSha512(key: BITCOIN_SEED, data: seed)
        let privateKey = hmac.prefix(PRIVATE_KEY_SIZE)
        let chainCode = hmac.suffix(from: PRIVATE_KEY_SIZE)

        let ib = privateKey.toBigInt()
        if ib == 0 || ib >= Secp256k1CurveConstants.n {
            throw NSError(domain: "Invalid key", code: 0, userInfo: nil)
        }

        return Key(privateKey: privateKey, chainCode: chainCode)
    }

    private static func calculateChecksum(entropy: Data, bits: Int) -> String {
        let hash = Data(SHA256.hash(data: entropy))
        let hashBits = hash.toBinaryString()
        return String(hashBits.prefix(bits))
    }

    private static func isValidPrivateKey(privateKey: Data) throws -> Bool {
        // Ensure private key is exactly 32 bytes
        guard privateKey.count == 32 else {
            print("Invalid private key length: must be 32 bytes.")
            return false
        }

        // Convert private key to BigUInt
        let privateKeyValue = BigUInt(privateKey)

        // Check if private key is within the valid range (0 < key < curve order)
        if privateKeyValue > 0 && privateKeyValue < Secp256k1CurveConstants.n {
            return true
        } else {
            print("Private key is out of valid range.")
            return false
        }
    }
}
