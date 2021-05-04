import Foundation

open class XyoWitness {
    public let address: XyoAddress
    
    public init(_ address: XyoAddress) {
        self.address = address
    }
    
    open func observe() -> XyoPayload? {
        return nil
    }
    
    open func previousHash() -> String? {
        return nil
    }
}
