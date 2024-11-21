import Foundation

public protocol AccountStatic {
    // associatedtype T: AccountInstance
    // associatedtype C: XyoPayload

    // static func create(options: C?) async throws -> T
    static func fromPrivateKey(key: Data?) -> AccountInstance
    static func random() -> AccountInstance
    static var previousHashStore: PreviousHashStore { get set }
}
