import Foundation

public class ApiResponseEnvelope<T: Decodable>: Decodable {
    public var data: T? = nil

    enum CodingKeys: String, CodingKey {
        case data
    }

    // Required initializer to conform to Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
