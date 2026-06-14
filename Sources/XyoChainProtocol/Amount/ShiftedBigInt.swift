import BigInt
import Foundation

/// Configuration for rendering a base-unit `BigInt` as a fixed-point decimal string.
/// Mirrors the Android `ShiftedBigIntConfig`.
public struct ShiftedBigIntConfig {
    public let places: Int
    public let maxDecimal: Int
    public let maxCharacters: Int
    public let minDecimals: Int
    public let locale: Locale

    public init(
        places: Int = 18,
        maxDecimal: Int = 18,
        maxCharacters: Int = 9,
        minDecimals: Int = 1,
        locale: Locale = Locale(identifier: "en_US")
    ) {
        self.places = places
        self.maxDecimal = maxDecimal
        self.maxCharacters = maxCharacters
        self.minDecimals = minDecimals
        self.locale = locale
    }
}

/// Renders a `BigInt` scaled by `10^places` as a grouped, floor-truncated decimal string.
/// Port of the Android `ShiftedBigInt`. Uses exact `BigInt` arithmetic (not `Decimal`) so it
/// stays correct for the full XL1 value range (up to 10^32).
///
/// Note: there are no cross-SDK vectors for formatting; this matches the Android logic for the
/// `en_US` locale (`,` grouping, `.` decimal separator).
public struct ShiftedBigInt {
    public let value: BigInt
    public let config: ShiftedBigIntConfig

    public init(_ value: BigInt, config: ShiftedBigIntConfig = ShiftedBigIntConfig()) {
        self.value = value
        self.config = config
    }

    public func toFullString() -> String {
        return ShiftedBigInt.formatDecimal(
            value: value, places: config.places, maxDecimal: config.places,
            maxCharacters: Int.max, minDecimals: config.places, locale: config.locale)
    }

    public func toShortString() -> String {
        return ShiftedBigInt.formatDecimal(
            value: value, places: config.places, maxDecimal: config.maxDecimal,
            maxCharacters: config.maxCharacters, minDecimals: config.minDecimals,
            locale: config.locale)
    }

    static func formatDecimal(
        value: BigInt, places: Int, maxDecimal: Int, maxCharacters: Int, minDecimals: Int,
        locale: Locale
    ) -> String {
        let symbols = separators(for: locale)
        let negative = value < 0
        let magnitude = value.magnitude  // BigUInt

        if places == 0 {
            return (negative ? "-" : "") + group(String(magnitude), grouping: symbols.grouping)
        }

        let scaleDivisor = BigUInt(10).power(places)
        let intPart = magnitude / scaleDivisor
        let remainder = magnitude % scaleDivisor
        let intStr = String(intPart)

        var availableDecimals = maxCharacters == Int.max ? maxDecimal : maxCharacters - intStr.count - 1
        availableDecimals = max(availableDecimals, minDecimals)
        availableDecimals = min(availableDecimals, maxDecimal)
        availableDecimals = max(availableDecimals, 0)

        var fraction = fractionDigits(
            remainder: remainder, places: places, decimals: availableDecimals)

        // Pattern keeps `minDecimals` fixed digits; trailing zeros beyond that are optional.
        if availableDecimals > minDecimals {
            while fraction.count > minDecimals && fraction.hasSuffix("0") {
                fraction.removeLast()
            }
        }

        let grouped = group(intStr, grouping: symbols.grouping)
        let sign = negative ? "-" : ""
        if fraction.isEmpty {
            return sign + grouped
        }
        return sign + grouped + symbols.decimal + fraction
    }

    /// First `decimals` fractional digits of `remainder / 10^places`, floor-truncated and
    /// zero-padded.
    private static func fractionDigits(remainder: BigUInt, places: Int, decimals: Int) -> String {
        if decimals == 0 { return "" }
        if decimals >= places {
            let remStr = String(remainder)
            let padded = String(repeating: "0", count: max(0, places - remStr.count)) + remStr
            return padded + String(repeating: "0", count: decimals - places)
        }
        let truncDivisor = BigUInt(10).power(places - decimals)
        let truncated = remainder / truncDivisor
        let truncStr = String(truncated)
        return String(repeating: "0", count: max(0, decimals - truncStr.count)) + truncStr
    }

    /// Insert grouping separators every three digits from the right.
    private static func group(_ digits: String, grouping: String) -> String {
        guard digits.count > 3 else { return digits }
        var result = ""
        var count = 0
        for character in digits.reversed() {
            if count != 0 && count % 3 == 0 {
                result.append(contentsOf: grouping.reversed())
            }
            result.append(character)
            count += 1
        }
        return String(result.reversed())
    }

    private static func separators(for locale: Locale) -> (grouping: String, decimal: String) {
        let grouping = locale.groupingSeparator ?? ","
        let decimal = locale.decimalSeparator ?? "."
        return (grouping, decimal)
    }
}
