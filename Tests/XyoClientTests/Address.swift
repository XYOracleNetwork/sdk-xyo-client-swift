import XCTest
@testable import XyoClient

let testVectorPrivateKey = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60"
let testVectorPublicKey = "d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a"

let testPrivateKey = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
let testPublicKey = "67d3b5eaf0c0bf6b5a602d359daecc86a7a74053490ec37ae08e71360587c870"

@available(iOS 13.0, *)
final class AddressTests: XCTestCase {
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
