import Foundation

open class XyoPayloadWrapper {
    
    public var payload: XyoPayload
    private var validator: XyoPayloadValidator
    
    public init(_ payload: XyoPayload) {
        self.payload = payload
        self.validator = XyoPayloadValidator(payload)
    }
}
