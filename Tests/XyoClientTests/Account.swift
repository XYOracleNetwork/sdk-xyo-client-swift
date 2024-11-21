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
        XCTAssertNotNil(account)
        XCTAssertNil(account.previousHash)
    }

    func testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned1() throws {
        // Arrange
        let account = Account.random()
        let _ = try account.sign(hash: testPayload1Hash)
        
        // Assert
        XCTAssertNotNil(account)
        XCTAssertEqual(account.previousHash, testPayload1Hash)
    }
    
    func testAccount_PreviousHash_IsPreviousHash_WhenPreviouslySigned2() throws {
        // Arrange
        let account = Account.random()
        let _ = try account.sign(hash: testPayload2Hash)
        
        // Assert
        XCTAssertNotNil(account)
        XCTAssertEqual(account.previousHash, testPayload2Hash)
    }
}
