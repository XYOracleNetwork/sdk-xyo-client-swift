import Foundation

open class Payload: Encodable {
    public init(_ schema: String) {
        self.schema = schema.lowercased()
    }
    public var schema: String
}

extension Payload {
    public func hash() throws -> Hash {
        return try BoundWitnessBuilder.hash(self)
    }
}
