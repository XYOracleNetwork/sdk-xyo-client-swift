import Foundation
import Alamofire

public struct XyoApiBoundWitnnessBody: Encodable {
    var boundWitnesses: [XyoBoundWitnessJson]
    var payloads: [XyoPayload]?
}

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
        try self.postBoundWitnesses(entries) {_error in}
    }
    
    public func postBoundWitnesses (
        _ entries: [XyoBoundWitnessJson],
        _ closure: @escaping (_ error: String?) -> Void
    ) throws {
        let body = entries
        AF.request(
            "\(self.config.apiDomain)/archive/\(self.config.archive)/block",
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.default
        ).responseJSON(queue: XyoArchivistApiClient.queue) { response in
            switch response.result {
            case .failure( _):
                XyoArchivistApiClient.mainQueue.async {
                    if let data = response.data {
                        closure(String(decoding: data, as: UTF8.self))
                    } else {
                        closure("Unknown Error")
                    }
                }
                
            case .success( _):
                XyoArchivistApiClient.mainQueue.async {
                    closure(nil)
                }
            }
        }
    }
    
    public func postBoundWitness(
        _ entry: XyoBoundWitnessJson
    ) throws {
        try self.postBoundWitnesses([entry]) {_error in}
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
