import CoreData
import XCTest

@testable import XyoClient

final class CoreDataPreviousHashStoreTests: XCTestCase {
    var provider: TestPersistentContainerProvider!
    var store: CoreDataPreviousHashStore!

    override func setUp() {
        super.setUp()
        // Initialize the test provider and store
        provider = TestPersistentContainerProvider()
        store = CoreDataPreviousHashStore(provider: provider)
    }

    override func tearDown() {
        // Clean up after tests
        provider = nil
        store = nil
        super.tearDown()
    }

    func testSetItemAndGetItem() {
        let address = Data("2d0fb5708b9d68bfaa96c6e426cbc66a341f117d")!
        let hash = Data("fb2b2ed349278d35b2cf32ec719227cf2a0f099f3a3305307bce15362eca32b9")!

        // Set an item
        store.setItem(address: address, previousHash: hash)

        // Get the item and verify it was stored correctly
        let retrievedHash = store.getItem(address: address)
        XCTAssertEqual(retrievedHash, hash, "Retrieved hash should match the stored hash.")
    }

    func testRemoveItem() {
        let address = Data("f90b9ad30ea94d3df17d51c727c416b46faf18b6")!
        let hash = Data("8a76ed3fa2507859e43f24ea0e6c03acb1782281429294bb8123b6d9e73f1710")!

        // Set an item
        store.setItem(address: address, previousHash: hash)

        // Remove the item
        store.removeItem(address: address)

        // Verify the item is removed
        let retrievedHash = store.getItem(address: address)
        XCTAssertNil(retrievedHash, "Hash should be nil after removal.")
    }

    func testUpdateItem() {
        let address = Data("85e7a0494c1feb184a80d64aca7bef07d8efd960")!
        let initialHash = Data("6c509659288d86d4961906299692239d40e5e3a8834ab89a473d9031e50703e0")!
        let updatedHash = Data("c2842590d989afae0bf2970b31d0323f97fe68c71a1c9d13bf275bbed13cf92c")!

        // Set an initial item
        store.setItem(address: address, previousHash: initialHash)

        // Update the item with a new hash
        store.setItem(address: address, previousHash: updatedHash)

        // Verify the item was updated
        let retrievedHash = store.getItem(address: address)
        XCTAssertEqual(retrievedHash, updatedHash, "Hash should match the updated value.")
    }

    func testGetItemNonExistentAddress() {
        let address = Data("f8ede235dbc41c06936d46a26d9038a58ba254a1")!

        // Try to get an item that doesn't exist
        let retrievedHash = store.getItem(address: address)

        // Verify the result is nil
        XCTAssertNil(retrievedHash, "Hash should be nil for a non-existent address.")
    }
}
