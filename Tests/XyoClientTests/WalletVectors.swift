import XCTest

@testable import XyoClient

struct TestVector: Decodable {
    let phrase: String
    let path: String
    let address: String
    let privateKey: String
    let publicKey: String
}

let phrase = "later puppy sound rebuild rebuild noise ozone amazing hope broccoli crystal grief"

let testVectors: [TestVector] = [
    .init(
        phrase: phrase,
        path: "m/44'/60'/0'/0/0",
        address: "e46c258c74c7c1df33d7caa4c2c664dc0843ab3f",
        privateKey: "96a7705eedbb701a03ee235911253fd3eb80e48a06106c0bf957d42b72bd8efa",
        //        publicKey: "a9f10779cb44e73a1983b8225ce9de96ff63cbc8a2900db102fa55a38a14b206f850a6decf0d0277c8ea237d865a06b6237f07eaf4273217ed6b2ed830161bef"
        publicKey: "03a9f10779cb44e73a1983b8225ce9de96ff63cbc8a2900db102fa55a38a14b206"
    )
]

class WalletVectorTests: XCTestCase {

    func test_vectors() {
        do {
            let vector = testVectors[0]

            let wallet = try Wallet(phrase: vector.phrase, path: vector.path)
            XCTAssertEqual(wallet.privateKey?.toHex(), vector.privateKey)
            XCTAssertEqual(wallet.address?.toHex(), vector.address)
            XCTAssertEqual(wallet.publicKey?.toHex(), vector.publicKey)

            let entropy = try Bip39.mnemonicToEntropy(phrase: vector.phrase)
            let seed = try Bip39.entropyToSeed(entropy: entropy)
            let pk = try Bip39.rootPrivateKeyFromSeed(seed: seed)
            let pkDerived = try Wallet.deriveKey(from: pk, path: vector.path)
            let wallet2 = try Wallet(key: pkDerived)
            XCTAssertEqual(wallet2.privateKey?.toHex(), vector.privateKey)
            XCTAssertEqual(wallet2.address?.toHex(), vector.address)
            XCTAssertEqual(wallet2.publicKey?.toHex(), vector.publicKey)
        } catch {
            print("\nCaught error: \(error)\n")
            XCTAssertTrue(false)
        }
    }
}
