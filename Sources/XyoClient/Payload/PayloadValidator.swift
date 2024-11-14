import Foundation

open class PayloadValidator {
    public var payload: Payload
    private var schemaValidator: SchemaValidator

    public init(_ payload: Payload) {
        self.payload = payload
        self.schemaValidator = SchemaValidator(payload.schema)
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
