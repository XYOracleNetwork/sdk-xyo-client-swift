public protocol Module {
    var address: Address? { get }
    var account: AccountInstance { get }
    var previousHash: Hash? { get }
}
