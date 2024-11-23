import Foundation

open class Payload: Encodable {
    public init(_ schema: String) {
        self.schema = schema.lowercased()
    }
    public var schema: String
}

extension Payload {

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

        // Encode `self` to JSON data
        let data = try encoder.encode(self)

        // Decode the JSON into a dictionary and filter keys
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw BoundWitnessBuilderError.encodingError
        }

        let filteredJSON = jsonObject.filter { !$0.key.hasPrefix("_") }

        // Encode the filtered dictionary back into JSON data
        let filteredData = try JSONSerialization.data(withJSONObject: filteredJSON, options: [.sortedKeys])

        // Convert the JSON data into a string
        guard let jsonString = String(data: filteredData, encoding: .utf16) else {
            throw BoundWitnessBuilderError.encodingError
        }

        // Hash the JSON string
        return try jsonString.sha256()
    }
}
