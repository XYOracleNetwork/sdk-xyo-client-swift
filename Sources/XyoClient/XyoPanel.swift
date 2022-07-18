import Foundation

public enum XyoPanelError: Error {
    case postToArchivistFailed
}

public class XyoPanel {
    
    public init(archivists: [XyoArchivistApiClient], witnesses: [XyoWitness]) {
        self._archivists = archivists
        self._witnesses = witnesses
    }
    
    public convenience init(archive: String? = nil, apiDomain: String? = nil, witnesses: [XyoWitness]? = nil, token: String? = nil) {
        let apiConfig = XyoArchivistApiConfig(archive ?? XyoPanel.Defaults.apiArchive, apiDomain ?? XyoPanel.Defaults.apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        self.init(archivists: [archivist], witnesses: witnesses ?? [])
    }
    
    public convenience init(observe: ((_ previousHash: String?) -> XyoEventPayload?)?) {
        if (observe != nil) {
            var witnesses = [XyoWitness]()
            
            if let observe = observe {
                witnesses.append(XyoEventWitness(observe))
            }

            self.init(witnesses: witnesses)
        } else {
            self.init()
        }
    }
    
    public typealias XyoPanelReportCallback = (([String])->Void)
    
    private var _archivists: [XyoArchivistApiClient]
    private var _witnesses: [XyoWitness]
    private var _previous_hash: String?
    
    public func report() throws {
        try report(nil)
    }
    
    public func event(_ event: String, _ closure: XyoPanelReportCallback?) throws {
        try report([XyoEventWitness { previousHash in XyoEventPayload(event, previousHash) }], closure)
    }
    
    public func report(_ adhocWitnesses: [XyoWitness], _ closure: XyoPanelReportCallback?) throws {
        var witnesses: [XyoWitness] = []
        witnesses.append(contentsOf: adhocWitnesses)
        witnesses.append(contentsOf: self._witnesses)
        let payloads = witnesses.map { witness in
            witness.observe()
        }
        let bw = try BoundWitnessBuilder()
            .payloads(payloads.compactMap { $0 })
            .witnesses(witnesses)
            .build(_previous_hash)
        self._previous_hash = bw._hash
        var errors: [String] = []
        var archivistCount = _archivists.count
        try _archivists.forEach { archivist in
            try archivist.postBoundWitness(bw) { error in
                archivistCount = archivistCount - 1
                if let errorExists = error {
                    errors.append(errorExists)
                }
                if (archivistCount == 0) {
                    closure?(errors)
                }
            }
        }
    }
    
    public func report(_ closure: XyoPanelReportCallback?) throws {
        return try self.report([], closure)
    }
    
    struct Defaults {
        static let apiArchive = "temp"
        static let apiDomain = "https://beta.api.archivist.xyo.network"
    }
    
    private static var defaultArchivist: XyoArchivistApiClient {
        get {
            let apiConfig = XyoArchivistApiConfig(self.Defaults.apiArchive, self.Defaults.apiDomain)
            return XyoArchivistApiClient.get(apiConfig)
        }
    }
}
