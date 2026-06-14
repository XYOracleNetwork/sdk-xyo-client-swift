import Foundation

/// Field exclusion mode for canonical serialization.
///
/// Per the XYO Yellow Paper (and the authoritative JS implementation):
/// - ``none``: No fields excluded (raw serialization).
/// - ``storageMeta``: Exclude top-level `_`-prefixed fields (used for `hash()`).
/// - ``allMeta``: Exclude top-level `_` AND `$`-prefixed fields (used for `dataHash()`).
public enum MetaExclusion {
    case none
    case storageMeta
    case allMeta
}

/// Produces a canonical JSON string with sorted keys and optional meta-field exclusion,
/// matching the authoritative JS pipeline
/// (`JSON.stringify(sortFields(removeEmptyFields(omitBy(obj, '_'))))`) and the Android
/// `JsonSerializable.canonicalJsonString`.
///
/// Key rules reproduced here, byte-for-byte:
/// - Keys are sorted lexicographically at **every** depth.
/// - Meta-field exclusion is applied **only at the top level** (depth 0).
/// - `null` is preserved everywhere (only JS `undefined` is dropped; that has no JSON form).
/// - Integers render without a decimal point; non-ASCII stays raw UTF-8 (no `\u` escapes).
enum Canonicalizer {

    /// Canonicalize raw JSON `Data`.
    static func canonicalJson(from data: Data, exclusion: MetaExclusion) throws -> String {
        let object = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
        return canonicalValue(object, exclusion: exclusion, depth: 0)
    }

    /// Canonicalize a raw JSON string.
    static func canonicalJson(fromString json: String, exclusion: MetaExclusion) throws -> String {
        guard let data = json.data(using: .utf8) else {
            throw PayloadBuilderError.encodingError
        }
        return try canonicalJson(from: data, exclusion: exclusion)
    }

    private static func canonicalObject(
        _ object: [String: Any], exclusion: MetaExclusion, depth: Int
    ) -> String {
        let keys = object.keys.sorted().filter { key in
            guard depth == 0 else { return true }
            switch exclusion {
            case .allMeta: return !key.hasPrefix("_") && !key.hasPrefix("$")
            case .storageMeta: return !key.hasPrefix("_")
            case .none: return true
            }
        }
        let entries = keys.map { key -> String in
            let valueString = canonicalValue(
                object[key] as Any, exclusion: exclusion, depth: depth + 1)
            return "\"\(escape(key))\":\(valueString)"
        }
        return "{\(entries.joined(separator: ","))}"
    }

    private static func canonicalArray(
        _ array: [Any], exclusion: MetaExclusion, depth: Int
    ) -> String {
        let elements = array.map { canonicalValue($0, exclusion: exclusion, depth: depth) }
        return "[\(elements.joined(separator: ","))]"
    }

    private static func canonicalValue(
        _ value: Any, exclusion: MetaExclusion, depth: Int
    ) -> String {
        switch value {
        case let dictionary as [String: Any]:
            return canonicalObject(dictionary, exclusion: exclusion, depth: depth)
        case let array as [Any]:
            return canonicalArray(array, exclusion: exclusion, depth: depth)
        case is NSNull:
            return "null"
        case let string as String:
            return "\"\(escape(string))\""
        case let number as NSNumber:
            return canonicalNumber(number)
        default:
            return "\"\(escape(String(describing: value)))\""
        }
    }

    /// Format a number to match JavaScript `JSON.stringify`: whole numbers render without a
    /// decimal point, otherwise the shortest round-trippable representation is used.
    private static func canonicalNumber(_ number: NSNumber) -> String {
        // `JSONSerialization` represents JSON booleans as `NSNumber` (a `__NSCFBoolean`);
        // detect and emit those first so `true`/`false` don't become `1`/`0`.
        if CFGetTypeID(number) == CFBooleanGetTypeID() {
            return number.boolValue ? "true" : "false"
        }
        let doubleValue = number.doubleValue
        if doubleValue.truncatingRemainder(dividingBy: 1) == 0
            && abs(doubleValue) < 9.223372036854775e18
        {
            return String(Int64(doubleValue))
        }
        return shortestDouble(doubleValue)
    }

    private static func shortestDouble(_ value: Double) -> String {
        // Swift's `Double` description is the shortest string that round-trips, matching the
        // JS Number-to-string algorithm for the finite decimal values found in payloads.
        return value.description
    }

    /// Escape a string for JSON output per the JSON spec, leaving non-ASCII characters raw
    /// (matching `JSON.stringify`).
    private static func escape(_ string: String) -> String {
        var output = ""
        output.reserveCapacity(string.unicodeScalars.count)
        for scalar in string.unicodeScalars {
            switch scalar {
            case "\"": output += "\\\""
            case "\\": output += "\\\\"
            case "\u{08}": output += "\\b"
            case "\u{0C}": output += "\\f"
            case "\n": output += "\\n"
            case "\r": output += "\\r"
            case "\t": output += "\\t"
            default:
                if scalar.value < 0x20 {
                    output += String(format: "\\u%04x", scalar.value)
                } else {
                    output.unicodeScalars.append(scalar)
                }
            }
        }
        return output
    }
}
