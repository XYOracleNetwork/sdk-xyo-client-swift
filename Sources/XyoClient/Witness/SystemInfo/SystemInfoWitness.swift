import Foundation

open class SystemInfoWitness: WitnessModuleSync {

    var allowPathMonitor: Bool

    public init(allowPathMonitor: Bool = false) {
        self.allowPathMonitor = allowPathMonitor
    }

    public override func observe() -> [EncodablePayloadInstance] {
        let payload = SystemInfoPayload(WifiInformation(allowPathMonitor))
        return [payload]
    }
}
