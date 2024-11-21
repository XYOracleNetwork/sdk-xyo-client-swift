import Foundation

public class XyoPanel {

    
    public typealias XyoPanelReportCallback = (([String]) -> Void)

    private var _archivists: [XyoArchivistApiClient]
    private var _witnesses: [WitnessModule]
    private let account: AccountInstance
    
    public init(
        account: AccountInstance,
        witnesses: [WitnessModule],
        archivists: [XyoArchivistApiClient]
    ) {
        self._archivists = archivists
        self._witnesses = witnesses
        self.account = account
    }

    public convenience init(
        account: AccountInstance? = nil,
        witnesses: [WitnessModule] = [],
        archive: String = XyoArchivistApiClient.DefaultArchivist,
        apiDomain: String = XyoArchivistApiClient.DefaultApiDomain
    ) {
        let panelAccount = account ?? Account.random()
        let apiConfig = XyoArchivistApiConfig(archive, apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        self.init(account: panelAccount, witnesses: witnesses, archivists: [archivist])
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

    @available(iOS 15, *)
    public func report() async -> [Payload] {
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

        // Insert witnessed results into archivists
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
        }
        return payloads
    }

    @available(iOS 15, *)
    public func reportQuery() async -> ModuleQueryResult {
        do {
            // Report
            let reportedResults = await self.report()

            // sign the results
            let (bw, payloads) = try BoundWitnessBuilder()
                .payloads(reportedResults)
                .signers([self.account])
                .build()

            return ModuleQueryResult(bw: bw, payloads: payloads, errors: [])
        } catch {
            print("Error in reportQuery: \(error)")
            // Return an empty ModuleQueryResult in case of an error
            return ModuleQueryResult(bw: BoundWitness(), payloads: [], errors: [])
        }
    }
}
