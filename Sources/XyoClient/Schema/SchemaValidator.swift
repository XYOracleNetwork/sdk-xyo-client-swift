import Foundation

open class SchemaValidator {
    public var schema: String
    public var parts: [Substring]

    public init(_ schema: String) {
        self.schema = schema
        self.parts = schema.split(separator: ".")
    }

    public var levels: Int {
        return self.parts.count
    }

    var isLowercase: Bool {
        return self.schema == self.schema.lowercased()
    }

    private func domainLevel(_ level: Int) -> String {
        return self.parts[0..<(level + 1)].reversed().joined(separator: ".")
    }

    var rootDomain: String {
        return self.domainLevel(1)
    }

    public func rootDomainExists(_ closure: (_ exists: Bool) -> Void) {
        // domainExists(this.rootDomain, closure)
        closure(true)
    }

    public func allDynamic(closure: (_ errors: [String]) -> Void) {
        var errors: [String] = []
        if self.schema.isEmpty {
            errors.append("schema missing")
            closure(errors)
        } else {
            self.rootDomainExists { exists in
                if !exists {
                    errors.append("schema root domain must exist [\(self.rootDomain)]")
                }
                closure(errors)
            }
        }
    }

    public func all() -> [String] {
        var errors: [String] = []
        if self.schema.isEmpty {
            errors.append("schema missing")
        } else if self.levels < 3 {
            errors.append("schema levels < 3 [\(self.levels), \(self.schema)]")
        } else if !self.isLowercase {
            errors.append("schema not lowercase [\(self.schema)]")
        }
        return errors
    }
}
