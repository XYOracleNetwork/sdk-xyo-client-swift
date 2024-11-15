import Foundation

public enum XyoPanelError: Error {
    case postToArchivistFailed
}

public class XyoPanel {

    public init(archivists: [XyoArchivistApiClient], witnesses: [AbstractSyncWitness]) {
        self._archivists = archivists
        self._witnesses = witnesses
    }

    public convenience init(
        archive: String? = nil, apiDomain: String? = nil, witnesses: [AbstractSyncWitness]? = nil,
        token: String? = nil
    ) {
        let apiConfig = XyoArchivistApiConfig(
            archive ?? XyoPanel.Defaults.apiModule, apiDomain ?? XyoPanel.Defaults.apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        self.init(archivists: [archivist], witnesses: witnesses ?? [])
    }

    public convenience init(observe: (() -> XyoEventPayload?)?) {
        if observe != nil {
            var witnesses = [AbstractSyncWitness]()

            if let observe = observe {
                witnesses.append(XyoEventWitness(observe))
            }

            self.init(witnesses: witnesses)
        } else {
            self.init()
        }
    }

    public typealias XyoPanelReportCallback = (([String]) -> Void)

    private var _archivists: [XyoArchivistApiClient]
    private var _witnesses: [AbstractSyncWitness]
    private var _previous_hash: String?
    
    @available(iOS 15, *)
    public func report() async throws
        -> [Payload]
    {
        let payloads = self._witnesses.map { witness in
            witness.observe()
        }.flatMap({ $0 })
        let (bw, _) = try BoundWitnessBuilder()
            .payloads(payloads)
            .signers(self._witnesses.map({ $0.account }))
            .build(_previous_hash)
        self._previous_hash = bw._hash
        var allResults: [[Payload]] = []
        await withTaskGroup(of: [Payload]?.self) { group in
            for instance in _archivists {
                group.addTask {
                    do {
                        return try await instance.insert(payloads: payloads)
                    } catch {
                        print("Error in insert for instance \(instance): \(error)")
                        return nil
                    }
                }
            }
            for await result in group {
                if let result = result {
                    allResults.append(result)
                }
            }
        }
        return allResults.flatMap { $0 }
    }

    struct Defaults {
        static let apiDomain =
            ProcessInfo.processInfo.environment["XYO_API_DOMAIN"]
            ?? "https://beta.api.archivist.xyo.network"
        static let apiModule = ProcessInfo.processInfo.environment["XYO_API_MODULE"] ?? "Archivist"
    }

    private static var defaultArchivist: XyoArchivistApiClient {
        XyoArchivistApiClient.get(
            XyoArchivistApiConfig(self.Defaults.apiModule, self.Defaults.apiDomain))
    }
}
