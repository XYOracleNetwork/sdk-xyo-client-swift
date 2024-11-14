import Alamofire
import Foundation

public class XyoArchivistApiClient {

    private static let ArchivistInsertQuerySchema = "network.xyo.query.archivist.insert"
    private static let ArchivistInsertQuery: Payload = Payload(ArchivistInsertQuerySchema)

    let config: XyoArchivistApiConfig
    let queryAccount: AccountInstance
    public var authenticated: Bool {
        return self.token != nil
    }

    public var token: String? {
        get {
            return self.config.token
        }
        set {
            self.config.token = newValue
        }
    }

    public var url: String {
        return "\(self.config.apiDomain)/\(self.config.apiModule)"
    }

    private init(_ config: XyoArchivistApiConfig, _ account: AccountInstance?) {
        self.config = config
        self.queryAccount = account ?? Account()
    }

    @available(iOS 15, *)
    public func insert(payloads: [Payload]) async throws -> [Payload] {
        // Build QueryBoundWitness
        let (bw, signed) = try BoundWitnessBuilder()
            .payloads(payloads)
            .signer(self.queryAccount)
            .query(XyoArchivistApiClient.ArchivistInsertQuery)
            .build()

        // Perform the request and await the result
        let responseData = try await AF.request(
            self.url,
            method: .post,
            parameters: ModuleQueryResult(bw: bw, payloads: signed),
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData()
        .value

        // let responseString = String(data: responseData, encoding: .utf8)
        // print(responseString ?? "Failed to convert response data to String")

        // Attempt to decode the response data
        let decodedResponse = try JSONDecoder().decode(
            ApiResponseEnvelope<ModuleQueryResult>.self, from: responseData)
        if decodedResponse.data?.bw.payload_hashes.count == payloads.count {
            // TODO: Deeper guard checks like hash, etc.
            // TODO: Return Success
            return payloads
        } else {
            // TODO: Indicate Error
            return []
        }
    }

    public static func get(_ config: XyoArchivistApiConfig) -> XyoArchivistApiClient {
        return XyoArchivistApiClient(config, Account())
    }
}

extension XyoArchivistApiClient {
    static fileprivate let queue = DispatchQueue(
        label: "network.xyo.requests.queue",
        qos: .utility,
        attributes: [.concurrent]
    )
    static fileprivate let mainQueue = DispatchQueue.main
}
