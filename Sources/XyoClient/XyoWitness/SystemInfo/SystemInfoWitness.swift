import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    public init() {
        super.init()
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        return XyoSystemInfoPayload(previousHash)
    }
}
