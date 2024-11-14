import Foundation

open class XyoBasicWitness: AbstractWitness {

    public typealias TPayloadOut = Payload

    public init(observer: @escaping ObserverClosure) {
        _observer = observer
        super.init()
    }

    public init(account: AccountInstance, observer: @escaping ObserverClosure) {
        _observer = observer
        super.init(account: account)
    }

    public typealias ObserverClosure = (() -> Payload?)

    private let _observer: ObserverClosure

    override public func observe() -> [Payload] {
        if let payload = _observer() {
            return [payload]
        } else {
            return []
        }
    }
}
