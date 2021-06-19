import Foundation

open class XyoBasicWitness: XyoWitness {
    
    public init(_ observer: @escaping ObserverClosure) throws {
        _observer = observer
        try super.init()
    }
    
    public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) throws {
        _observer = observer
        try super.init(address)
    }
    
    public typealias ObserverClosure = ((_ previousHash: String?)->XyoBasicPayload?)
    
    private let _observer: ObserverClosure
    
    override public func observe() throws -> XyoBasicPayload? {
        let payload = _observer(previousHash)
        previousHash = try payload?.sha256()
        return payload
    }
}
