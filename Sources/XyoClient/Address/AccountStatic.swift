import Foundation

public protocol AccountStatic {
    // associatedtype T: AccountInstance
    // associatedtype C: XyoPayload
    
    // static func create(options: C?) async throws -> T
    // static func fromPrivateKey(key: Data) async throws -> AccountInstance
    static func random() async throws -> AccountInstance
}
