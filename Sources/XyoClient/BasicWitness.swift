import Foundation

public class XyoBasicWitness: XyoWitness {
    
    public init(_ observer: @escaping ObserverClosure) throws {
        _observer = observer
        try super.init()
    }
    
    public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) throws {
        _observer = observer
        try super.init(address)
    }
    
    public typealias ObserverClosure = (()->XyoPayload?)
    
    private let _observer: ObserverClosure
    
    override public func observe() -> XyoPayload? {
        return _observer()
    }
}
