import BigInt
import Foundation

/// The smallest XL1 denomination (0 decimal places). All internal calculations use `AttoXL1`
/// as the base unit. Matches the Android `AttoXL1` value class.
public struct AttoXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "AttoXL1 value must be non-negative")
        precondition(value <= AttoXL1.maxValue, "AttoXL1 value exceeds maximum: \(AttoXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.atto)
    public static let zero = AttoXL1(0)

    public static func of(_ value: BigInt) -> AttoXL1 { AttoXL1(value) }

    public static func ofOrNull(_ value: BigInt) -> AttoXL1? {
        (value >= 0 && value <= maxValue) ? AttoXL1(value) : nil
    }

    public static func fromHex(_ hex: String) -> AttoXL1 {
        let clean = hex.hasPrefix("0x") ? String(hex.dropFirst(2)) : hex
        return AttoXL1(BigInt(clean, radix: 16)!)
    }

    public static func fromHexOrNull(_ hex: String) -> AttoXL1? {
        let clean = hex.hasPrefix("0x") ? String(hex.dropFirst(2)) : hex
        guard let parsed = BigInt(clean, radix: 16) else { return nil }
        return ofOrNull(parsed)
    }

    public func toHex() -> String { "0x" + String(value, radix: 16) }

    public static func + (lhs: AttoXL1, rhs: AttoXL1) -> AttoXL1 { AttoXL1(lhs.value + rhs.value) }
    public static func - (lhs: AttoXL1, rhs: AttoXL1) -> AttoXL1 { AttoXL1(lhs.value - rhs.value) }
    public static func < (lhs: AttoXL1, rhs: AttoXL1) -> Bool { lhs.value < rhs.value }

    public var description: String { value.description }
}
