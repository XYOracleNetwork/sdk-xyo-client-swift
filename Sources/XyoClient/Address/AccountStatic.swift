import Foundation

public protocol AccountStatic {
    static func fromPrivateKey(_ key: Data) throws -> AccountInstance
    static func fromPrivateKey(_ key: String) throws -> AccountInstance
    static func random() -> AccountInstance
    static var previousHashStore: PreviousHashStore { get set }
}
