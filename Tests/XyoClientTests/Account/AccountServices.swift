import XCTest

@testable import XyoClient

class AccountServicesTests: XCTestCase {

    static var allTests = [
        (
            "testGetNamedAccount_CreatesAndReturnsNewAccount_WhenNoExistingAccount",
            testGetNamedAccount_CreatesAndReturnsNewAccount_WhenNoExistingAccount
        ),
        (
            "testGetNamedAccount_ReturnsExistingAccount_WhenAccountExists",
            testGetNamedAccount_ReturnsExistingAccount_WhenAccountExists
        ),
    ]

    func testGetNamedAccount_CreatesAndReturnsNewAccount_WhenNoExistingAccount() {
        // Act
        let account = AccountServices.getNamedAccount(name: "testAccount1")

        // Assert
        XCTAssertNotNil(account)
        XCTAssertNotNil(account.address)
    }

    func testGetNamedAccount_ReturnsExistingAccount_WhenAccountExists() {
        // Act
        // Initial attempt create account
        let accountA = AccountServices.getNamedAccount(name: "testAccount2")
        // Subsequent ones retrieve account
        let accountB = AccountServices.getNamedAccount(name: "testAccount2")

        // Asserts
        let addressA = accountA.address
        let addressB = accountB.address
        XCTAssertNotNil(addressA)
        XCTAssertNotNil(addressB)
        XCTAssertEqual(addressA, addressB)
    }

}
