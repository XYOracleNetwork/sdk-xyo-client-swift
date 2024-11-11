import Foundation

open class XyoPayload: Encodable {
  public init(_ schema: String) {
    self.schema = schema.lowercased()
  }
  public var schema: String
}
