import Foundation

open class XyoPayload:Codable {
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("adhoc", forKey: .schema)
    }
    
    open func schema() -> String {
        return "adhoc"
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
