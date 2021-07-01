import Foundation

open class XyoPayload: Encodable {
    
    public init(_ schema: String, _ previousHash: String? = nil) {
        self.schema = schema
        self.previousHash = previousHash
    }
    
    public var schema: String
    public var previousHash: String?
    
    func sha256() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(self)
        
        guard let str = String(data: data, encoding: .utf8) else {
            throw BoundWitnessBuilderError.encodingError
        }
        return try str.sha256()
    }
}
