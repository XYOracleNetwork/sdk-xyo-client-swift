import Foundation

open class PayloadWrapper {

    public var payload: Payload
    private var validator: PayloadValidator

    public init(_ payload: Payload) {
        self.payload = payload
        self.validator = PayloadValidator(payload)
    }
}
