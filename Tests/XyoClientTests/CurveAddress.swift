import XCTest
@testable import XyoClient

let testVectorPrivateKey = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60"
let testVectorPublicKey = "667fef5f7578a801037ed144092dcf7c7c44e3bf3e09cfc8a67fcf70fcd8123a"

let testPrivateKey = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
let testPublicKey = "be9a880a7f5334a8e50bd701bd38c6def25369c7084b5be4d5b1022886835212"

final class CurveAddressTests: XCTestCase {
    static var allTests = [
        ("testGeneratedPrivateKey", testGeneratedPrivateKey),
        ("testKnownPrivateKey", testKnownPrivateKey),
        ("testPhrasePrivateKey", testPhrasePrivateKey),
    ]
    
    func testGeneratedPrivateKey() throws {
        let address = try XyoAddress()
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKey?.count, 64)
        XCTAssertEqual(address.publicKey?.count, 64)
    }
    
    func testKnownPrivateKey() throws {
        let address = try XyoAddress(key: testVectorPrivateKey)
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKey, testVectorPrivateKey)
        XCTAssertEqual(address.publicKey, testVectorPublicKey)
    }
    
    func testPhrasePrivateKey() throws {
        let address = try XyoAddress(phrase: "test")
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKey, testPrivateKey)
        XCTAssertEqual(address.publicKey, testPublicKey)
    }
}
