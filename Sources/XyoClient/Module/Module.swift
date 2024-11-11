public protocol Module {
  var address: String? { get }
  var account: AccountInstance { get }
  var previousHash: String? { get }
}
