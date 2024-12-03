import Foundation

public protocol WalletInstance: AccountInstance {
    func derivePath(path: String) throws -> WalletInstance
}
