import Foundation
import Alamofire
import SwiftyJSON

class XyoArchivistApi {
  let config: XyoArchivistApiConfig
  static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
  static fileprivate let mainQueue = DispatchQueue.main
  private init(_ config: XyoArchivistApiConfig) {
    self.config = config
  }

  public var authenticated : Bool {
    get {
      return self.config.token != nil
    }
  }

  public func postBoundWitnesses(
    entries: [JSON],
    closure: @escaping (_ data: [JSON]?, _ error: Error?) -> ()
  ) {
    AF.request(
      "\(self.config.apiDomain)/archive/\(self.config.archive)/bw",
      method: .post,
      parameters: entries,
      encoder: JSONParameterEncoder.default
    ).responseJSON(queue: XyoArchivistApi.queue) { response in
      switch response.result {
      case .failure(let error):
        XyoArchivistApi.mainQueue.async {
              closure(nil, error)
          }

      case .success(let data):
        XyoArchivistApi.mainQueue.async {
              closure((data as? [JSON]) ?? [], nil)
          }
      }
    }
  }

  public func postBoundWitness(
    entries: JSON,
    closure: @escaping (_ data: [JSON]?, _ error: Error?) -> ()
  ) {
    AF.request(
      "\(self.config.apiDomain)/archive/\(self.config.archive)/bw",
      method: .post,
      parameters: entries,
      encoder: JSONParameterEncoder.default
    ).responseJSON(queue: XyoArchivistApi.queue) { response in
      switch response.result {
      case .failure(let error):
        XyoArchivistApi.mainQueue.async {
              closure(nil, error)
          }

      case .success(let data):
        XyoArchivistApi.mainQueue.async {
              closure((data as? [JSON]) ?? [], nil)
          }
      }
    }
  }

  static func get(_ config: XyoArchivistApiConfig) -> XyoArchivistApi {
    return XyoArchivistApi(config)
  }
}
