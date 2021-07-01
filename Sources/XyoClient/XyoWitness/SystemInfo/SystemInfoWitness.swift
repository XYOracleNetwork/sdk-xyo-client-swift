import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    public init() throws {
        super.init()
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        return XyoSystemInfoPayload()
    }
}
