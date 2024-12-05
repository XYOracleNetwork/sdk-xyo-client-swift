import XCTest

@testable import XyoClient

struct TestVector: Decodable {
    let address: String
    let path: String
    let phrase: String
    let privateKey: String
    let publicKey: String
    let publicKeyUncompressed: String
}

let testCases: [TestVector] = [
    .init(
        address: "e46c258c74c7c1df33d7caa4c2c664dc0843ab3f",
        path: "m/44'/60'/0'/0/0",
        phrase: "later puppy sound rebuild rebuild noise ozone amazing hope broccoli crystal grief",
        privateKey: "96a7705eedbb701a03ee235911253fd3eb80e48a06106c0bf957d42b72bd8efa",
        publicKey: "03a9f10779cb44e73a1983b8225ce9de96ff63cbc8a2900db102fa55a38a14b206",
        publicKeyUncompressed:
            "04a9f10779cb44e73a1983b8225ce9de96ff63cbc8a2900db102fa55a38a14b206f850a6decf0d0277c8ea237d865a06b6237f07eaf4273217ed6b2ed830161bef"
    )
]

class WalletVectorTests: XCTestCase {

    func testCreationFromPrivateKey() {
        for vector in testCases {
            do {
                let entropy = try Bip39.mnemonicToEntropy(phrase: vector.phrase)
                let seed = try Bip39.entropyToSeed(entropy: entropy)
                let pk = try Bip39.rootPrivateKeyFromSeed(seed: seed)
                let pkDerived = try Wallet.deriveKey(from: pk, path: vector.path)
                let wallet2 = try Wallet(key: pkDerived)
                XCTAssertEqual(wallet2.privateKey?.toHex(), vector.privateKey)
                XCTAssertEqual(wallet2.address?.toHex(), vector.address)
                XCTAssertEqual(wallet2.publicKey?.toHex(), vector.publicKey)
                XCTAssertEqual(wallet2.publicKeyUncompressed?.toHex(), vector.publicKeyUncompressed)
            } catch {
                print("\nCaught error: \(error)\n")
                XCTAssertTrue(false)
            }
        }
    }

    func testCreationFromPhrase() {
        for vector in testCases {
            do {
                let wallet = try Wallet(phrase: vector.phrase, path: vector.path)
                XCTAssertEqual(wallet.privateKey?.toHex(), vector.privateKey)
                XCTAssertEqual(wallet.address?.toHex(), vector.address)
                XCTAssertEqual(wallet.publicKey?.toHex(), vector.publicKey)
                XCTAssertEqual(wallet.publicKeyUncompressed?.toHex(), vector.publicKeyUncompressed)
            } catch {
                print("\nCaught error: \(error)\n")
                XCTAssertTrue(false)
            }
        }
    }
}
