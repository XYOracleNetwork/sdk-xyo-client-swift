import Foundation

public enum XyoPanelError: Error {
    case postToArchivistFailed
}

public class XyoPanel {

    public init(archivists: [XyoArchivistApiClient], witnesses: [WitnessModule]) {
        self._archivists = archivists
        self._witnesses = witnesses
    }

    public convenience init(
        archive: String? = nil, apiDomain: String? = nil, witnesses: [WitnessModule]? = nil,
        token: String? = nil
    ) {
        let apiConfig = XyoArchivistApiConfig(
            archive ?? XyoPanel.Defaults.apiModule, apiDomain ?? XyoPanel.Defaults.apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        self.init(archivists: [archivist], witnesses: witnesses ?? [])
    }

    public convenience init(observe: (() -> XyoEventPayload?)?) {
        if observe != nil {
            var witnesses = [WitnessModuleSync]()

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
    private var _witnesses: [WitnessModule]
    private var _previous_hash: String?

    @available(iOS 15, *)
    public func report() async throws
        -> [Payload]
    {
        var payloads: [Payload] = []

        // Collect payloads from both synchronous and asynchronous witnesses
        for witness in _witnesses {
            if let syncWitness = witness as? WitnessSync {
                // For synchronous witnesses, call the sync `observe` method directly
                payloads.append(contentsOf: syncWitness.observe())
            } else if let asyncWitness = witness as? WitnessAsync {
                // For asynchronous witnesses, call the async `observe` method using `await`
                do {
                    let asyncPayloads = try await asyncWitness.observe()
                    payloads.append(contentsOf: asyncPayloads)
                } catch {
                    print("Error observing async witness: \(error)")
                    // Handle error as needed, possibly continue or throw
                }
            }
        }

        // Build the BoundWitness
        let (bw, _) = try BoundWitnessBuilder()
            .payloads(payloads)
            .signers(self._witnesses.map { $0.account })
            .build(_previous_hash)
        self._previous_hash = bw._hash

        // Collect results from archivists using async tasks
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

    @available(iOS 15, *)
    public func reportQuery() async throws
        -> ModuleQueryResult
    {
        var payloads: [Payload] = []

        // Collect payloads from both synchronous and asynchronous witnesses
        for witness in _witnesses {
            if let syncWitness = witness as? WitnessSync {
                // For synchronous witnesses, call the sync `observe` method directly
                payloads.append(contentsOf: syncWitness.observe())
            } else if let asyncWitness = witness as? WitnessAsync {
                // For asynchronous witnesses, call the async `observe` method using `await`
                do {
                    let asyncPayloads = try await asyncWitness.observe()
                    payloads.append(contentsOf: asyncPayloads)
                } catch {
                    print("Error observing async witness: \(error)")
                    // Handle error as needed, possibly continue or throw
                }
            }
        }

        // Build the BoundWitness
        let (bw, _) = try BoundWitnessBuilder()
            .payloads(payloads)
            .signers(self._witnesses.map { $0.account })
            .build(_previous_hash)
        self._previous_hash = bw._hash

        // Collect results from archivists using async tasks
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
        let ret: ModuleQueryResult = .init(bw: bw, payloads: allResults.flatMap { $0 }, errors: [])
        return ret
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
