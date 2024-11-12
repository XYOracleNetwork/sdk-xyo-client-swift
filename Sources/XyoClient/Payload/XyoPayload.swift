import Foundation

open class XyoPayload: Encodable, Decodable {
  public init(_ schema: String) {
    self.schema = schema.lowercased()
  }
  public var schema: String
}

extension XyoPayload {

  /// Generates a SHA-256 hash of the encoded representation of the instance.
  ///
  /// This method serializes the instance using JSON encoding with sorted keys,
  /// converts the encoded data into a UTF-8 string, and then applies SHA-256
  /// hashing to generate a hash of the instance's contents.
  ///
  /// - Throws:
  ///   - `BoundWitnessBuilderError.encodingError` if the instance cannot be
  ///     converted to a UTF-8 string after encoding.
  ///   - Any error thrown by the `sha256()` function if the hashing process fails.
  /// - Returns: A `Data` object containing the SHA-256 hash of the encoded instance.
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
