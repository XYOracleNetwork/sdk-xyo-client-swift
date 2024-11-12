import Foundation

public class Account: XyoAddress, AccountInstance, AccountStatic {
    public typealias T = <#type#>
    
    public typealias C = <#type#>
    
    public var address: Address = ""
    
    public var addressBytes: Data
    
    public var previousHash: Hash?
    
    public var previousHashBytes: Data?
    
    public var `private`: Data?
    
    public var `public`: Data?
    
    public func sign(hash: Data, previousHash: Data?) async throws -> Data {
        <#code#>
    }
    
    public func verify(msg: Data, signature: Data) async throws -> Bool {
        <#code#>
    }
    
    public typealias T = <#type#>
    
    public typealias C = <#type#>
    
    public static func fromPrivateKey(key: Data) async throws -> any AccountInstance {
        <#code#>
    }
    
    public static func random() async throws -> any AccountInstance {
        <#code#>
    }
    
    
}
