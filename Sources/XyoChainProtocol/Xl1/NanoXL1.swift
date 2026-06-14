import BigInt
import Foundation

/// XL1 denomination at 9 decimal places from `AttoXL1` (1 NanoXL1 = 10^9 AttoXL1).
public struct NanoXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "NanoXL1 value must be non-negative")
        precondition(value <= NanoXL1.maxValue, "NanoXL1 value exceeds maximum: \(NanoXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.nano)
    public static let zero = NanoXL1(0)

    public static func of(_ value: BigInt) -> NanoXL1 { NanoXL1(value) }
    public static func ofOrNull(_ value: BigInt) -> NanoXL1? {
        (value >= 0 && value <= maxValue) ? NanoXL1(value) : nil
    }

    public static func + (lhs: NanoXL1, rhs: NanoXL1) -> NanoXL1 { NanoXL1(lhs.value + rhs.value) }
    public static func - (lhs: NanoXL1, rhs: NanoXL1) -> NanoXL1 { NanoXL1(lhs.value - rhs.value) }
    public static func < (lhs: NanoXL1, rhs: NanoXL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.nano) }
    public var description: String { value.description }
}
