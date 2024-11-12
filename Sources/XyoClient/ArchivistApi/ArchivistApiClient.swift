import Alamofire
import Foundation

public struct XyoApiBoundWitnessBody: Encodable {
  var boundWitnesses: [XyoBoundWitnessJson]
  var payloads: [XyoPayload]?
}

struct ModuleQueryResult: Encodable {
  let bw: XyoBoundWitnessJson
  let payloads: [XyoPayload]
  let errors: [XyoPayload]
  init(bw: XyoBoundWitnessJson, payloads: [XyoPayload] = [], errors: [XyoPayload] = []) {
    self.bw = bw
    self.payloads = payloads
    self.errors = errors
  }
  func encode(to encoder: Encoder) throws {
    // Create an unkeyed container for array encoding
    var container = encoder.unkeyedContainer()
    // Encode `bw` as the first element
    try container.encode(bw)
    // Encode `payloads` as the second element
    try container.encode(payloads)
    // Encode `errors` as the third element
    try container.encode(errors)
  }
}

public class XyoArchivistApiClient {

  private static let ArchivistInsertQuerySchema = "network.xyo.query.archivist.insert"
  private static let ArchivistInsertQuery: XyoPayload = XyoPayload(ArchivistInsertQuerySchema)

  let config: XyoArchivistApiConfig

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

  private init(_ config: XyoArchivistApiConfig) {
    self.config = config
  }

  public func insert(payloads: [XyoPayload]) async throws -> XyoBoundWitnessJson {
    // Build QueryBoundWitness
    let (bw, signed) = try BoundWitnessBuilder()
      .payloads(payloads)
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
    // TODO: Return payloads instead once they're deserializable
    return decodedResponse[0]
  }

  public func postBoundWitnesses(
    _ entries: [XyoBoundWitnessJson]
  ) throws {
    try self.postBoundWitnesses(entries) { _ in }
  }

  public func postBoundWitnesses(
    _ entries: [XyoBoundWitnessJson],
    _ closure: @escaping (_ error: String?) -> Void
  ) throws {
    let body = entries
    AF.request(
      self.url,
      method: .post,
      parameters: body,
      encoder: JSONParameterEncoder.default
    ).validate().responseData(queue: XyoArchivistApiClient.queue) { response in
      switch response.result {
      case .failure:
        XyoArchivistApiClient.mainQueue.async {
          if let data = response.data {
            closure(String(decoding: data, as: UTF8.self))
          } else {
            closure("Unknown Error")
          }
        }

      case .success:
        XyoArchivistApiClient.mainQueue.async {
          closure(nil)
        }
      }
    }
  }

  public func postBoundWitness(
    _ entry: XyoBoundWitnessJson
  ) throws {
    try self.postBoundWitnesses([entry]) { _ in }
  }

  public func postBoundWitness(
    _ entry: XyoBoundWitnessJson,
    _ closure: @escaping (_ error: String?) -> Void
  ) throws {
    try self.postBoundWitnesses([entry], closure)
  }

  public static func get(_ config: XyoArchivistApiConfig) -> XyoArchivistApiClient {
    return XyoArchivistApiClient(config)
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
