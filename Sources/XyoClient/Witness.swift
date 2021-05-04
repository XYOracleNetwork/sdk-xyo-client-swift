import Foundation

open class XyoWitness {
    public let address: XyoAddress
    
    public init(_ address: XyoAddress? = nil) throws {
        self.address = try address ?? XyoAddress()
    }
    
    open func observe() -> XyoPayload? {
        return nil
    }
    
    open func previousHash() -> String? {
        return nil
    }
}
