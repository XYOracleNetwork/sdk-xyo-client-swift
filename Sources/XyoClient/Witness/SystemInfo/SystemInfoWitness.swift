import Foundation

open class XyoSystemInfoWitness: AbstractWitness {

    var allowPathMonitor: Bool

    public init(allowPathMonitor: Bool = false) {
        self.allowPathMonitor = allowPathMonitor
    }

    public override func observe() -> [Payload] {
        let payload = XyoSystemInfoPayload(WifiInformation(allowPathMonitor))
        return [payload]
    }
}
