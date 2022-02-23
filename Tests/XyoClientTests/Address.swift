import XCTest
@testable import XyoClient

let testVectorPrivateKey = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60"
let testVectorPublicKey = "8db55b05db86c0b1786ca49f095d76344c9e6056b2f02701a7e7f3c20aabfd913ebbe148dd17c56551a52952371071a6c604b3f3abe8f2c8fa742158ea6dd7d4"
let testVectorKeccak = "a33e4932f3f7349eb63b379e09231da7b19a016f9e576d23b16277062f4d46a8"
let testVectorAddress = "09231da7b19a016f9e576d23b16277062f4d46a8"

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
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKeyHex, testVectorPrivateKey)
        XCTAssertEqual(address.publicKeyHex, testVectorPublicKey)
        XCTAssertEqual(address.keccakHex, testVectorKeccak)
        XCTAssertEqual(address.addressHex, testVectorAddress)
    }
}
