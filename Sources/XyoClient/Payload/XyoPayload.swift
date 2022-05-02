import Foundation

open class XyoPayload: Encodable {
    
    public init(_ schema: String, _ previousHash: String? = nil) {
        self.schema = schema.lowercased()
        self.previousHash = previousHash
    }
    
    public var schema: String
    public var previousHash: String?
    
    public func hash() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(self)
        
        guard let str = String(data: data, encoding: .utf8) else {
            throw BoundWitnessBuilderError.encodingError
        }
        return try str.sha256()
    }
}
