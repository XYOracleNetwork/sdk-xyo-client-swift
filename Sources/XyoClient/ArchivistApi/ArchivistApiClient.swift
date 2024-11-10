import Alamofire
import Foundation

public struct XyoApiBoundWitnessBody: Encodable {
  var boundWitnesses: [XyoBoundWitnessJson]
  var payloads: [XyoPayload]?
}

public class XyoArchivistApiClient {
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

  private init(_ config: XyoArchivistApiConfig) {
    self.config = config
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
      "\(self.config.apiDomain)/\(self.config.apiModule)",
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
  static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
  static fileprivate let mainQueue = DispatchQueue.main
}
