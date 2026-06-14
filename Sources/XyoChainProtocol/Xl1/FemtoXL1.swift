import BigInt
import Foundation

/// XL1 denomination at 3 decimal places from `AttoXL1` (1 FemtoXL1 = 10^3 AttoXL1).
public struct FemtoXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "FemtoXL1 value must be non-negative")
        precondition(value <= FemtoXL1.maxValue, "FemtoXL1 value exceeds maximum: \(FemtoXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.femto)
    public static let zero = FemtoXL1(0)

    public static func of(_ value: BigInt) -> FemtoXL1 { FemtoXL1(value) }
    public static func ofOrNull(_ value: BigInt) -> FemtoXL1? {
        (value >= 0 && value <= maxValue) ? FemtoXL1(value) : nil
    }

    public static func + (lhs: FemtoXL1, rhs: FemtoXL1) -> FemtoXL1 { FemtoXL1(lhs.value + rhs.value) }
    public static func - (lhs: FemtoXL1, rhs: FemtoXL1) -> FemtoXL1 { FemtoXL1(lhs.value - rhs.value) }
    public static func < (lhs: FemtoXL1, rhs: FemtoXL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.femto) }
    public var description: String { value.description }
}
