import Foundation

open class XyoWitness {
    public let address: XyoAddress?
    public var previousHash: String?
    
    public init(_ address: XyoAddress? = nil, previousHash: String? = nil) {
        self.address = address ?? XyoAddress()
        self.previousHash = previousHash
    }
    
    open func observe() -> XyoPayload? {
        preconditionFailure("This method must be overridden")
    }
}
