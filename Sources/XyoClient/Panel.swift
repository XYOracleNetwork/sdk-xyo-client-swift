import Foundation

public enum XyoPanelError: Error {
    case postToArchivistFailed
}

public class XyoPanel {
    
    private init(_ archivists: [XyoArchivistApiClient], _ witnesses: [XyoWitness]) {
        _archivists = archivists
        _witnesses = witnesses
    }
    
    public typealias XyoPanelReportCallback = (([Error])->Void)
    
    private var _archivists: [XyoArchivistApiClient]
    private var _witnesses: [XyoWitness]
    
    public func report(closure:@escaping XyoPanelReportCallback) throws {
        var errors: [Error] = []
        let payloads = self._witnesses.map { witness in
            witness.observe()
        }
        let bw = try BoundWitnessBuilder()
            .payloads(payloads.compactMap { $0 })
            .witnesses(self._witnesses)
            .build()
        let _ = try _archivists.map { archivist in
            try archivist.postBoundWitness(bw) { count, error in
                if error != nil {
                    errors.append(XyoPanelError.postToArchivistFailed)
                }
            }
        }
        closure(errors)
    }
    
    struct Defaults {
        static let apiArchive = "default"
        static let apiDomain = "https://archivist.xyo.network"
    }
    
    private static var defaultArchivist: XyoArchivistApiClient {
        get {
            let apiConfig = XyoArchivistApiConfig(self.Defaults.apiArchive, self.Defaults.apiDomain)
            return XyoArchivistApiClient.get(apiConfig)
        }
    }
    
    public static func get(archive: String?, apiDomain: String?, token: String?, witnesses: [XyoWitness]?) throws -> XyoPanel {
        let apiConfig = XyoArchivistApiConfig(archive ?? self.Defaults.apiArchive, apiDomain ?? self.Defaults.apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        return XyoPanel([archivist], try witnesses ?? [XyoWitness(try XyoAddress())])
    }
}
