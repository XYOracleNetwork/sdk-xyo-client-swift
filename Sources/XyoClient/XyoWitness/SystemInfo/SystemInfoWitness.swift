import Foundation

open class XyoSystemInfoWitness: XyoWitness {
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoSystemInfoPayload?)
    
    override public func observe() -> XyoSystemInfoPayload? {
        let payload = XyoSystemInfoPayload(previousHash)
        previousHash = try? payload.hash()
        return payload
    }
}
