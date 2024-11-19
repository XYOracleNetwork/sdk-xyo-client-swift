public protocol PreviousHashStore {
    func getItem(address: Address) -> Hash?
    func removeItem(address: Address)
    func setItem(address: Address, previousHash: Hash)
}
