import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    
    public init() throws {
        try super.init()
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() throws -> XyoSystemInfoPayload? {
        return XyoSystemInfoPayload()
    }
}
