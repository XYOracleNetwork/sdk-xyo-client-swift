import XCTest

@testable import XyoClient

let testVectorPrivateKey = "7f71bc5644f8f521f7e9b73f7a391e82c05432f8a9d36c44d6b1edbf1d8db62f"
let testVectorPublicKey =
    "ed6f3b86542f45aab88ec48ab1366b462bd993fec83e234054afd8f2311fba774800fdb40c04918463b463a6044b83413a604550bfba8f8911beb65475d6528e"
let testVectorKeccak = "0889fa0b3d5bb98e749c7bf75e7a847447e7fec41011ae7d32d768f86605ba03"
let testVectorAddress = "5e7a847447e7fec41011ae7d32d768f86605ba03"
let testVectorHash = "4b688df40bcedbe641ddb16ff0a1842d9c67ea1c3bf63f3e0471baa664531d1a"
let testVectorSignature =
    "b61dad551e910e2793b4f9f880125b5799086510ce102fad0222c1b093c60a6bc755ca10a9068079ac8d9617416a7cd41077093061c1e9bcb2f81812086ae603"

final class AddressTests: XCTestCase {
    static var allTests = [
        ("testGeneratedPrivateKey", testGeneratedPrivateKey),
        ("testKnownPrivateKey", testKnownPrivateKey),
    ]

    func testGeneratedPrivateKey() {
        let address = XyoAddress()
        XCTAssertNotNil(address)

        XCTAssertEqual(address.privateKeyBytes?.count, 32)
        XCTAssertEqual(address.publicKeyBytes?.count, 64)
        XCTAssertEqual(address.keccakBytes?.count, 32)
        XCTAssertEqual(address.addressBytes?.count, 20)

        XCTAssertEqual(address.privateKeyHex?.count, 64)
        XCTAssertEqual(address.publicKeyHex?.count, 128)
        XCTAssertEqual(address.keccakHex?.count, 64)
        XCTAssertEqual(address.addressHex?.count, 40)
    }

    func testKnownPrivateKey() {
        let address = XyoAddress(privateKey: testVectorPrivateKey)
        // let signature = try? address.sign(testVectorHash)
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKeyHex, testVectorPrivateKey)
        XCTAssertEqual(address.publicKeyHex, testVectorPublicKey)
        XCTAssertEqual(address.keccakHex, testVectorKeccak)
        XCTAssertEqual(address.addressHex, testVectorAddress)
    }
}
