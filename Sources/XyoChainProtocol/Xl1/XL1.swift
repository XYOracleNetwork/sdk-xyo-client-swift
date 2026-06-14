import BigInt
import Foundation

/// The largest XL1 denomination (18 decimal places from `AttoXL1`). 1 XL1 = 10^18 AttoXL1.
public struct XL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "XL1 value must be non-negative")
        precondition(value <= XL1.maxValue, "XL1 value exceeds maximum: \(XL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.xl1)
    public static let zero = XL1(0)

    public static func of(_ value: BigInt) -> XL1 { XL1(value) }
    public static func ofOrNull(_ value: BigInt) -> XL1? {
        (value >= 0 && value <= maxValue) ? XL1(value) : nil
    }

    public static func + (lhs: XL1, rhs: XL1) -> XL1 { XL1(lhs.value + rhs.value) }
    public static func - (lhs: XL1, rhs: XL1) -> XL1 { XL1(lhs.value - rhs.value) }
    public static func < (lhs: XL1, rhs: XL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.xl1) }
    public var description: String { value.description }
}
