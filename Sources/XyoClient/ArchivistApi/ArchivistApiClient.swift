import Foundation
import Alamofire

public class XyoArchivistApiClient {
    let config: XyoArchivistApiConfig
    
    public var authenticated: Bool {
        get {
            return self.token != nil
        }
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
        try self.postBoundWitnesses(entries) {_count, _error in}
    }
    
    public func postBoundWitnesses (
        _ entries: [XyoBoundWitnessJson],
        _ closure: @escaping (_ count: Int?, _ error: Error?) -> Void
    ) throws {
        AF.request(
            "\(self.config.apiDomain)/archive/\(self.config.archive)/bw",
            method: .post,
            parameters: entries,
            encoder: JSONParameterEncoder.default
        ).responseJSON(queue: XyoArchivistApiClient.queue) { response in
            switch response.result {
            case .failure(let error):
                XyoArchivistApiClient.mainQueue.async {
                    closure(nil, error)
                }
                
            case .success(let data):
                XyoArchivistApiClient.mainQueue.async {
                    closure(data as? Int, nil)
                }
            }
        }
    }
    
    public func postBoundWitness(
        _ entry: XyoBoundWitnessJson
    ) throws {
        try self.postBoundWitnesses([entry]) {_count, _error in}
    }
    
    public func postBoundWitness(
        _ entry: XyoBoundWitnessJson,
        _ closure: @escaping (_ count: Int?, _ error: Error?) -> Void
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
