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

        let accountServices = AccountServices()

        // Act
        let account = accountServices.getNamedAccount(name: "testAccount")

        // Assert
        XCTAssertNotNil(account)
        XCTAssertNotNil(account.address)
    }

    func testGetNamedAccount_ReturnsExistingAccount_WhenAccountExists() {
        let accountServices = AccountServices()

        // Act
        // Initial attempt create account
        let accountA = accountServices.getNamedAccount(name: "testAccount")
        // Subsequent ones retrieve account
        let accountB = accountServices.getNamedAccount(name: "testAccount")

        // Asserts
        let addressA = accountA.address
        let addressB = accountB.address
        XCTAssertNotNil(addressA)
        XCTAssertNotNil(addressB)
        XCTAssertEqual(addressA, addressB)
    }

}
