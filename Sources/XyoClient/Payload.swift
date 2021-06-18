import Foundation

open class XyoPayload: Encodable {
    
    init(_ schema: String) {
        self.schema = schema
    }
    
    public var schema: String
    
    open func encode(to encoder: Encoder) throws {
        fatalError("Override required")
    }
    
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
