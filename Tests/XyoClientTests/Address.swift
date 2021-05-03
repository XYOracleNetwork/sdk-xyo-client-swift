import XCTest
@testable import XyoClient

let knownPrivateKey = "8deb979933d0e8931074b81ce9005223a65d9b51d0b18a2801b7f61f9d42ff04"
let knownPublicKey = "55a19a825939b46287cfd182ad2004132051c4be5c4684e4d0d50066f941b382"

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
    let address = try XyoAddress(key: knownPrivateKey)
    XCTAssertNotNil(address)
    XCTAssertEqual(address.privateKey, knownPrivateKey)
    XCTAssertEqual(address.publicKey, knownPublicKey)
  }
  
  func testPhrasePrivateKey() throws {
    let address = try XyoAddress(phrase: "test")
    XCTAssertNotNil(address)
    XCTAssertEqual(address.privateKey, testPrivateKey)
    XCTAssertEqual(address.publicKey, testPublicKey)
  }
}
