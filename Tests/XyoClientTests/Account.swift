import XCTest

@testable import XyoClient

class AccountTests: XCTestCase {

    static var allTests = [
        (
            "testAccount_PreviousHash_IsNil_WhenNoPreviousSignings",
            testAccount_PreviousHash_IsNil_WhenNoPreviousSignings
        ),
        (
            "testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned1",
            testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned1
        ),
        (
            "testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned2",
            testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned2
        ),
    ]

    override func setUp() {
        super.setUp()
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func testAccount_PreviousHash_IsNil_WhenNoPreviousSignings() {
        // Arrange
        let account = Account.random()

        // Assert
        XCTAssertNil(account.previousHash)
    }

    func testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned1() throws {
        // Arrange
        let account = Account.random()
        let _ = try account.sign(testPayload1Hash)

        // Assert
        XCTAssertEqual(account.previousHash, testPayload1Hash)
    }

    func testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned2() throws {
        // Arrange
        let account = XyoAddress()
        let hexString = account.privateKeyHex!
        let key = Data.dataFrom(hexString: hexString)!

        // Act
        // Create an account from the private key
        let account1 = Account.fromPrivateKey(key)
        // Sign something so the previousHash is stored
        let _ = try account1.sign(testPayload2Hash)
        // Next account creation should hydrate previousHash from store
        let account2 = Account.fromPrivateKey(key)

        // Assert
        XCTAssertEqual(account1.previousHash, account2.previousHash)
    }
}
