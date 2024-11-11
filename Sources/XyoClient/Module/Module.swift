public protocol Module {
  var address: XyoAddress { get }
  var previousHash: String? { get }
}
