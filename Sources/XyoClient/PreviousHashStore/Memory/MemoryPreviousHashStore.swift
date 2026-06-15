public class MemoryPreviousHashStore: PreviousHashStore {
    private var store: [Address: Hash] = [:]

    public init() {}

    public func getItem(address: Address) -> Hash? {
        return store[address]
    }

    public func removeItem(address: Address) {
        store.removeValue(forKey: address)
    }

    public func setItem(address: Address, previousHash: Hash) {
        store[address] = previousHash
    }
}
