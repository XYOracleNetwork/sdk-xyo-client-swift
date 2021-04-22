import Foundation
import Alamofire

class XyoArchivistApiStatic {
  static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
  static fileprivate let mainQueue = DispatchQueue.main
}

class XyoArchivistApi {
  let config: XyoArchivistApiConfig
  private init(_ config: XyoArchivistApiConfig) {
    self.config = config
  }

  public var authenticated : Bool {
    get {
      return self.config.token != nil
    }
  }

  public func postBoundWitnesses (
    _ entries: [XyoBoundWitnessJson],
    _ closure: @escaping (_ count: Int?, _ error: Error?) -> ()
  ) throws {
    AF.request(
      "\(self.config.apiDomain)/archive/\(self.config.archive)/bw",
      method: .post,
      parameters: entries,
      encoder: JSONParameterEncoder.default
    ).responseJSON(queue: XyoArchivistApiStatic.queue) { response in
      switch response.result {
      case .failure(let error):
        XyoArchivistApiStatic.mainQueue.async {
              closure(nil, error)
          }

      case .success(let data):
        XyoArchivistApiStatic.mainQueue.async {
              closure(data as? Int, nil)
          }
      }
    }
  }

  public func postBoundWitness(
    _ entry: XyoBoundWitnessJson,
    _ closure: @escaping (_ count: Int?, _ error: Error?) -> ()
  ) throws {
    try self.postBoundWitnesses([entry], closure)
  }

  static func get(_ config: XyoArchivistApiConfig) -> XyoArchivistApi {
    return XyoArchivistApi(config)
  }
}
