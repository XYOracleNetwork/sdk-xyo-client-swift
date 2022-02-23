import XCTest
@testable import XyoClient

let testVectorPrivateKey = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60"
let testVectorPublicKey = "8db55b05db86c0b1786ca49f095d76344c9e6056b2f02701a7e7f3c20aabfd913ebbe148dd17c56551a52952371071a6c604b3f3abe8f2c8fa742158ea6dd7d4"
let testVectorAddress = "09231da7b19a016f9e576d23b16277062f4d46a8"

let testPrivateKey = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
let testPublicKey = "5f81956d5826bad7d30daed2b5c8c98e72046c1ec8323da336445476183fb7ca54ba511b8b782bc5085962412e8b9879496e3b60bebee7c36987d1d5848b9a50"
let testAddress = "2a260a110bc7b03f19c40a0bd04ff2c5dcb57594"

final class CurveAddressTests: XCTestCase {
    static var allTests = [
        ("testGeneratedPrivateKey", testGeneratedPrivateKey),
        ("testKnownPrivateKey", testKnownPrivateKey),
    ]
    
    func testGeneratedPrivateKey() {
        let address = XyoAddress()
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKeyHex?.count, 64)
        XCTAssertEqual(address.publicKeyHex?.count, 128)
        XCTAssertEqual(address.addressBytes?.count, 40)
    }
    
    func testKnownPrivateKey() {
        let address = XyoAddress(privateKey: testVectorPrivateKey)
        XCTAssertNotNil(address)
        XCTAssertEqual(address.privateKeyHex, testVectorPrivateKey)
        XCTAssertEqual(address.publicKeyHex, testVectorPublicKey)
        XCTAssertEqual(address.addressHex, testVectorAddress)
    }
}
