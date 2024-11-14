import Foundation

open class XyoPayloadWrapper {

    public var payload: Payload
    private var validator: XyoPayloadValidator

    public init(_ payload: Payload) {
        self.payload = payload
        self.validator = XyoPayloadValidator(payload)
    }
}
