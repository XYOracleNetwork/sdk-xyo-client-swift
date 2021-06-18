import Foundation

open class XyoPayload: Encodable {
    
    init(_ schema: String) {
        self.schema = schema
    }
    
    public var schema: String
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("adhoc", forKey: .schema)
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
