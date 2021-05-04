import Foundation

public class XyoBasicWitness: XyoWitness {
    
    public typealias ObserveClosure = (()->XyoPayload?)
    
    private let _observe: ObserveClosure?
    
    init(_ observe: ObserveClosure?) throws {
        self._observe = observe
        try super.init()
    }
}
