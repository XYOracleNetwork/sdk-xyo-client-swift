import Foundation

open class XyoPayloadValidator {
    public var payload: XyoPayload
    private var schemaValidator: XyoSchemaValidator
    
    public init(_ payload: XyoPayload) {
        self.payload = payload
        self.schemaValidator = XyoSchemaValidator(payload.schema)
    }
    
    public func allDynamic(closure: (_ errors: [String]) -> Void) {
        var errors: [String] = []
        self.schemaValidator.allDynamic { schemaErrors in
            errors.append(contentsOf: schemaErrors)
            closure(errors)
        }
    }

    public func all() -> [String] {
        var errors: [String] = []
        errors.append(contentsOf: self.schemaValidator.all())
        return errors
    }
}
