import BigInt
import Foundation

/// XL1 denomination at 12 decimal places from `AttoXL1` (1 MicroXL1 = 10^12 AttoXL1).
public struct MicroXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "MicroXL1 value must be non-negative")
        precondition(value <= MicroXL1.maxValue, "MicroXL1 value exceeds maximum: \(MicroXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.micro)
    public static let zero = MicroXL1(0)

    public static func of(_ value: BigInt) -> MicroXL1 { MicroXL1(value) }
    public static func ofOrNull(_ value: BigInt) -> MicroXL1? {
        (value >= 0 && value <= maxValue) ? MicroXL1(value) : nil
    }

    public static func + (lhs: MicroXL1, rhs: MicroXL1) -> MicroXL1 { MicroXL1(lhs.value + rhs.value) }
    public static func - (lhs: MicroXL1, rhs: MicroXL1) -> MicroXL1 { MicroXL1(lhs.value - rhs.value) }
    public static func < (lhs: MicroXL1, rhs: MicroXL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.micro) }
    public var description: String { value.description }
}
