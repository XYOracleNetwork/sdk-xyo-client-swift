import Foundation

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
