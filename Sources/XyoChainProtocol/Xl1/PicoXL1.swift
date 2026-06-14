import BigInt
import Foundation

/// XL1 denomination at 6 decimal places from `AttoXL1` (1 PicoXL1 = 10^6 AttoXL1).
public struct PicoXL1: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: BigInt

    public init(_ value: BigInt) {
        precondition(value >= 0, "PicoXL1 value must be non-negative")
        precondition(value <= PicoXL1.maxValue, "PicoXL1 value exceeds maximum: \(PicoXL1.maxValue)")
        self.value = value
    }

    public static let maxValue: BigInt = xl1MaxValue(XL1Places.pico)
    public static let zero = PicoXL1(0)

    public static func of(_ value: BigInt) -> PicoXL1 { PicoXL1(value) }
    public static func ofOrNull(_ value: BigInt) -> PicoXL1? {
        (value >= 0 && value <= maxValue) ? PicoXL1(value) : nil
    }

    public static func + (lhs: PicoXL1, rhs: PicoXL1) -> PicoXL1 { PicoXL1(lhs.value + rhs.value) }
    public static func - (lhs: PicoXL1, rhs: PicoXL1) -> PicoXL1 { PicoXL1(lhs.value - rhs.value) }
    public static func < (lhs: PicoXL1, rhs: PicoXL1) -> Bool { lhs.value < rhs.value }

    public func toAtto() -> AttoXL1 { AttoXL1(value * AttoXL1ConvertFactor.pico) }
    public var description: String { value.description }
}
