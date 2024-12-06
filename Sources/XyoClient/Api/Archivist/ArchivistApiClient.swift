import Alamofire
import Foundation

public class XyoArchivistApiClient {

    public static let DefaultApiDomain: String =
        ProcessInfo.processInfo.environment["XYO_API_DOMAIN"] ?? "https://api.archivist.xyo.network"
    public static let DefaultArchivist: String =
        ProcessInfo.processInfo.environment["XYO_API_MODULE"] ?? "Archivist"

    private static let ArchivistInsertQuerySchema = "network.xyo.query.archivist.insert"
    private static let ArchivistInsertQuery: EncodablePayloadInstance = EncodablePayloadInstance(
        ArchivistInsertQuerySchema)

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
        self.queryAccount =
            account ?? AccountServices.getNamedAccount(name: "DefaultArchivistApiClientAccount")
    }

    public func insert(
        payloads: [EncodablePayloadInstance],
        completion: @escaping ([EncodablePayloadInstance]?, Error?) -> Void
    ) {
        do {
            // Build QueryBoundWitness
            let (bw, signed) = try BoundWitnessBuilder()
                .payloads(payloads)
                .signer(self.queryAccount)
                .query(XyoArchivistApiClient.ArchivistInsertQuery)
                .build()

            // Perform the request
            AF.request(
                self.url,
                method: .post,
                parameters: ModuleQueryResult(bw: bw, payloads: signed),
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let responseData):
                    do {
                        // Decode the response data
                        let decodedResponse = try JSONDecoder().decode(
                            ApiResponseEnvelope<ModuleQueryResult>.self, from: responseData
                        )

                        // Check if the response data matches the expected result
                        if decodedResponse.data?.bw.typedPayload.payload_hashes.count
                            == payloads.count
                        {
                            // Return the payloads array in case of success
                            completion(payloads, nil)
                        } else {
                            // Return an empty array if the counts don't match
                            completion([], nil)
                        }
                    } catch {
                        // Pass any decoding errors to the completion handler
                        completion(nil, error)
                    }

                case .failure(let error):
                    // Pass any request errors to the completion handler
                    completion(nil, error)
                }
            }

        } catch {
            // Handle synchronous errors (like errors from the BoundWitnessBuilder)
            completion(nil, error)
        }
    }

    @available(iOS 15, *)
    public func insert(payloads: [EncodablePayloadInstance]) async throws
        -> [EncodablePayloadInstance]
    {
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
        if decodedResponse.data?.bw.typedPayload.payload_hashes.count == payloads.count {
            // TODO: Deeper guard checks like hash, etc.
            // TODO: Return Success
            return payloads
        } else {
            // TODO: Indicate Error
            return []
        }
    }

    public static func get(_ config: XyoArchivistApiConfig) -> XyoArchivistApiClient {
        return XyoArchivistApiClient(config, Account.random())
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
