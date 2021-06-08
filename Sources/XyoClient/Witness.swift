import Foundation

open class XyoWitness {
    public let address: XyoAddress
    
    public init(_ address: XyoAddress? = nil) throws {
        self.address = try address ?? XyoAddress()
    }
    
    open func observe() -> XyoPayload? {
        preconditionFailure("This method must be overridden")
    }
    
    open func previousHash() -> String? {
        preconditionFailure("This method must be overridden")
    }
}
