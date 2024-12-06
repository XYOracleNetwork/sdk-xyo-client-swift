import Foundation

public enum XyoPanelError: Error {
    case failedToBuildBoundWitness
}

public class XyoPanel {

    public typealias XyoPanelReportCallback = (([String]) -> Void)

    private let _account: AccountInstance
    private let _archivists: [XyoArchivistApiClient]
    private let _witnesses: [WitnessModule]

    public var account: AccountInstance {
        _account
    }

    public init(
        account: AccountInstance,
        witnesses: [WitnessModule],
        archivists: [XyoArchivistApiClient]
    ) {
        self._archivists = archivists
        self._witnesses = witnesses
        self._account = account
    }

    public convenience init(
        account: AccountInstance? = nil,
        witnesses: [WitnessModule] = [],
        apiDomain: String = XyoArchivistApiClient.DefaultApiDomain,
        apiModule: String = XyoArchivistApiClient.DefaultArchivist
    ) {
        let panelAccount = account ?? AccountServices.getNamedAccount(name: "DefaultPanelAccount")
        let apiConfig = XyoArchivistApiConfig(apiModule, apiDomain)
        let archivist = XyoArchivistApiClient.get(apiConfig)
        self.init(account: panelAccount, witnesses: witnesses, archivists: [archivist])
    }

    @available(iOS 15, *)
    private func witnessAll() async -> [EncodablePayloadInstance] {
        var payloads: [EncodablePayloadInstance] = []
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
        return payloads
    }

    @available(iOS 15, *)
    public func storeWitnessedResults(payloads: [EncodablePayloadInstance]) async {
        // Insert witnessed results into archivists
        await withTaskGroup(of: [EncodablePayload]?.self) { group in
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
        return
    }

    @available(iOS 15, *)
    public func report() async -> [EncodablePayload] {
        // Report
        let results = await witnessAll()
        // Insert results into Archivists
        await storeWitnessedResults(payloads: results)
        // Return results
        return results
    }

    @available(iOS 15, *)
    public func reportQuery() async throws -> ModuleQueryResult {
        do {
            // Report
            let results = await witnessAll()

            // Sign the results
            let (bw, payloads) = try BoundWitnessBuilder()
                .payloads(results)
                .signers([self._account])
                .build()

            // Insert signed results into Archivists
            let signedResults: [EncodablePayloadInstance] = [bw.typedPayload] + payloads
            await storeWitnessedResults(payloads: signedResults)

            // Return signed results
            return ModuleQueryResult(bw: bw, payloads: payloads, errors: [])
        } catch {
            print("Error in reportQuery: \(error)")
            // Return an empty ModuleQueryResult in case of an error
            do {
                let (bw, payloads) = try BoundWitnessBuilder().build()
                return ModuleQueryResult(bw: bw, payloads: payloads, errors: [])
            } catch {

            }
        }
        throw XyoPanelError.failedToBuildBoundWitness
    }
}
