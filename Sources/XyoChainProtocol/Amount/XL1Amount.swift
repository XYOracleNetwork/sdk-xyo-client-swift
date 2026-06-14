import BigInt
import Foundation

/// High-level wrapper for XL1 amounts. Internally stores the value as `AttoXL1` (the smallest
/// unit) and provides conversions to every denomination plus locale-aware formatting.
/// Matches the Android `XL1Amount`.
public struct XL1Amount: Comparable, Equatable, CustomStringConvertible {
    public let value: AttoXL1
    private let locale: Locale

    private init(_ value: AttoXL1, locale: Locale = Locale(identifier: "en_US")) {
        self.value = value
        self.locale = locale
    }

    public var atto: AttoXL1 { value }
    public var femto: FemtoXL1 { FemtoXL1(value.value / AttoXL1ConvertFactor.femto) }
    public var pico: PicoXL1 { PicoXL1(value.value / AttoXL1ConvertFactor.pico) }
    public var nano: NanoXL1 { NanoXL1(value.value / AttoXL1ConvertFactor.nano) }
    public var micro: MicroXL1 { MicroXL1(value.value / AttoXL1ConvertFactor.micro) }
    public var milli: MilliXL1 { MilliXL1(value.value / AttoXL1ConvertFactor.milli) }
    public var xl1: XL1 { XL1(value.value / AttoXL1ConvertFactor.xl1) }

    public func toString(places: Int = XL1Places.atto, config: ShiftedBigIntConfig? = nil) -> String {
        let resolved = config ?? ShiftedBigIntConfig(places: places, locale: locale)
        return ShiftedBigInt(value.value, config: resolved).toShortString()
    }

    public func toFullString(places: Int = XL1Places.atto) -> String {
        return ShiftedBigInt(value.value, config: ShiftedBigIntConfig(places: places, locale: locale))
            .toFullString()
    }

    public var description: String { toString(places: XL1Places.xl1) }

    public static func + (lhs: XL1Amount, rhs: XL1Amount) -> XL1Amount {
        XL1Amount(lhs.value + rhs.value, locale: lhs.locale)
    }
    public static func - (lhs: XL1Amount, rhs: XL1Amount) -> XL1Amount {
        XL1Amount(lhs.value - rhs.value, locale: lhs.locale)
    }
    public static func < (lhs: XL1Amount, rhs: XL1Amount) -> Bool { lhs.value < rhs.value }
    public static func == (lhs: XL1Amount, rhs: XL1Amount) -> Bool { lhs.value == rhs.value }

    public static func fromAtto(_ value: BigInt, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        let clamped = clampToAttoRange(value)
        return XL1Amount(AttoXL1(clamped), locale: locale)
    }

    public static func fromAtto(_ value: AttoXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value, locale: locale)
    }
    public static func fromFemto(_ value: FemtoXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }
    public static func fromPico(_ value: PicoXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }
    public static func fromNano(_ value: NanoXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }
    public static func fromMicro(_ value: MicroXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }
    public static func fromMilli(_ value: MilliXL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }
    public static func fromXL1(_ value: XL1, locale: Locale = Locale(identifier: "en_US")) -> XL1Amount {
        XL1Amount(value.toAtto(), locale: locale)
    }

    public static func from(
        _ value: BigInt, places: Int = XL1Places.atto, locale: Locale = Locale(identifier: "en_US")
    ) -> XL1Amount {
        precondition(XL1Places.all.contains(places), "Invalid denomination places: \(places)")
        let attoValue = value * BigInt(10).power(places)
        return fromAtto(attoValue, locale: locale)
    }

    public static let zero = XL1Amount(AttoXL1.zero)

    private static func clampToAttoRange(_ value: BigInt) -> BigInt {
        if value < 0 { return 0 }
        if value > AttoXL1.maxValue { return AttoXL1.maxValue }
        return value
    }
}
