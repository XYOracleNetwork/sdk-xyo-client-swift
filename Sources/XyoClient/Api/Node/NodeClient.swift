import Alamofire
import Foundation

/// The request body for a node query: a 2-tuple `[QueryBoundWitness, payloads]` where the
/// payloads array includes the query payload itself. Encoded as a JSON array.
struct NodeQueryRequest: Encodable {
    let bw: EncodableBoundWitnessWithMeta
    let payloads: [EncodablePayloadInstance]

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(bw)
        try container.encode(payloads)
    }
}

/// Generic client for issuing module queries to an XYO node over HTTP. Mirrors the Android
/// `NodeClient`: builds a signed `QueryBoundWitness`, POSTs `[QBW, payloads]`, and parses the
/// `[bw, payloads, errors]` response envelope.
public final class NodeClient {
    public let url: String
    private let account: AccountInstance

    public init(url: String, account: AccountInstance? = nil) {
        self.url = url
        self.account = account ?? Account.random()
    }

    private func buildRequest(
        query: EncodablePayloadInstance, payloads: [EncodablePayloadInstance]?
    ) throws -> NodeQueryRequest {
        let builder = QueryBoundWitnessBuilder()
        if let payloads = payloads {
            _ = try builder.payloads(payloads)
        }
        let (bw, signed) = try builder.signer(account).query(query).build()
        return NodeQueryRequest(bw: bw, payloads: signed)
    }

    private func parse(_ data: Data) -> QueryResponse? {
        guard
            let envelope = try? JSONDecoder().decode(
                ApiResponseEnvelope<ModuleQueryResult>.self, from: data),
            let result = envelope.data
        else { return nil }
        let payloads = result.payloads.compactMap { $0 as? AnyPayload }
        return QueryResponse(bw: result.bw, payloads: payloads)
    }

    @available(iOS 15, *)
    public func query(
        _ query: EncodablePayloadInstance, payloads: [EncodablePayloadInstance]? = nil
    ) async throws -> PostQueryResult {
        let request = try buildRequest(query: query, payloads: payloads)
        do {
            let data = try await AF.request(
                url, method: .post, parameters: request, encoder: JSONParameterEncoder.default
            )
            .validate()
            .serializingData()
            .value
            return PostQueryResult(response: parse(data), errors: nil)
        } catch {
            return PostQueryResult(response: nil, errors: [error])
        }
    }

    public func query(
        _ query: EncodablePayloadInstance,
        payloads: [EncodablePayloadInstance]? = nil,
        completion: @escaping (PostQueryResult) -> Void
    ) {
        do {
            let request = try buildRequest(query: query, payloads: payloads)
            AF.request(
                url, method: .post, parameters: request, encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    completion(PostQueryResult(response: self?.parse(data), errors: nil))
                case .failure(let error):
                    completion(PostQueryResult(response: nil, errors: [error]))
                }
            }
        } catch {
            completion(PostQueryResult(response: nil, errors: [error]))
        }
    }
}
