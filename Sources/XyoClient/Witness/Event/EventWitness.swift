import Foundation

open class XyoEventWitness: WitnessModuleSync {

    public init(_ observer: @escaping ObserverClosure) {
        _observer = observer
        super.init()
    }

    public init(_ account: AccountInstance, _ observer: @escaping ObserverClosure) {
        _observer = observer
        super.init(account: account)
    }

    public typealias ObserverClosure = (() -> XyoEventPayload?)

    private let _observer: ObserverClosure

    public override func observe() -> [EncodablePayloadInstance] {
        if let payload = _observer() {
            return [payload]
        } else {
            return []
        }
    }
}
