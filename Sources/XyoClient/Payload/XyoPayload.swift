import Foundation

open class XyoPayload: Encodable {
  public init(_ schema: String) {
    self.schema = schema.lowercased()
  }
  public var schema: String
}

extension XyoPayload {

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
