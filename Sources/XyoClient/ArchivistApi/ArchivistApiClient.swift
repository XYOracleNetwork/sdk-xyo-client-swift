import Alamofire
import Foundation

public class XyoArchivistApiClient {

  private static let ArchivistInsertQuerySchema = "network.xyo.query.archivist.insert"
  private static let ArchivistInsertQuery: XyoPayload = XyoPayload(ArchivistInsertQuerySchema)

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

  public func insert(payloads: [XyoPayload]) async throws -> [XyoPayload] {
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

    // Attempt to decode the response data into XyoBoundWitnessJson
    let decodedResponse = try JSONDecoder().decode(ModuleQueryResult.self, from: responseData)

    return decodedResponse.payloads
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
