import BigInt
import Foundation

/// XL1 denomination at 15 decimal places from `AttoXL1` (1 MilliXL1 = 10^15 AttoXL1).
public struct MilliXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "MilliXL1 value must be non-negative")
        precondition(value <= MilliXL1.maxValue, "MilliXL1 value exceeds maximum: \(MilliXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.milli)
    public static let zero = MilliXL1(0)

    public static func of(_ value: BigInt) -> MilliXL1 { MilliXL1(value) }
    public static func ofOrNull(_ value: BigInt) -> MilliXL1? {
        (value >= 0 && value <= maxValue) ? MilliXL1(value) : nil
    }

    public static func + (lhs: MilliXL1, rhs: MilliXL1) -> MilliXL1 { MilliXL1(lhs.value + rhs.value) }
    public static func - (lhs: MilliXL1, rhs: MilliXL1) -> MilliXL1 { MilliXL1(lhs.value - rhs.value) }
    public static func < (lhs: MilliXL1, rhs: MilliXL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.milli) }
    public var description: String { value.description }
}
