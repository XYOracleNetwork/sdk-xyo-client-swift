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
        let address = "0x123456"
        let hash = "0xabcdef"

        // Set an item
        store.setItem(address: address, previousHash: hash)

        // Get the item and verify it was stored correctly
        let retrievedHash = store.getItem(address: address)
        XCTAssertEqual(retrievedHash, hash, "Retrieved hash should match the stored hash.")
    }

    func testRemoveItem() {
        let address = "0x123456"
        let hash = "0xabcdef"

        // Set an item
        store.setItem(address: address, previousHash: hash)

        // Remove the item
        store.removeItem(address: address)

        // Verify the item is removed
        let retrievedHash = store.getItem(address: address)
        XCTAssertNil(retrievedHash, "Hash should be nil after removal.")
    }

    func testUpdateItem() {
        let address = "0x123456"
        let initialHash = "0xabcdef"
        let updatedHash = "0x123abc"

        // Set an initial item
        store.setItem(address: address, previousHash: initialHash)

        // Update the item with a new hash
        store.setItem(address: address, previousHash: updatedHash)

        // Verify the item was updated
        let retrievedHash = store.getItem(address: address)
        XCTAssertEqual(retrievedHash, updatedHash, "Hash should match the updated value.")
    }

    func testGetItemNonExistentAddress() {
        let address = "0x789abc"

        // Try to get an item that doesn't exist
        let retrievedHash = store.getItem(address: address)

        // Verify the result is nil
        XCTAssertNil(retrievedHash, "Hash should be nil for a non-existent address.")
    }
}
