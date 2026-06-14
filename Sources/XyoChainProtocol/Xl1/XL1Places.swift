import BigInt
import Foundation

/// Decimal places for each XL1 denomination.
///
/// `AttoXL1` is the smallest unit (0 decimal places from base); `XL1` is the largest (18).
/// Matches the authoritative JS `XL1Units.ts` and the Android `XL1Places`.
public enum XL1Places {
    public static let atto: Int = 0
    public static let femto: Int = 3
    public static let pico: Int = 6
    public static let nano: Int = 9
    public static let micro: Int = 12
    public static let milli: Int = 15
    public static let xl1: Int = 18

    public static let all: [Int] = [atto, femto, pico, nano, micro, milli, xl1]
}

/// Conversion factors from `AttoXL1` to each denomination (`10^places`).
public enum AttoXL1ConvertFactor {
    public static let xl1: BigInt = BigInt(10).power(XL1Places.xl1)
    public static let milli: BigInt = BigInt(10).power(XL1Places.milli)
    public static let micro: BigInt = BigInt(10).power(XL1Places.micro)
    public static let nano: BigInt = BigInt(10).power(XL1Places.nano)
    public static let pico: BigInt = BigInt(10).power(XL1Places.pico)
    public static let femto: BigInt = BigInt(10).power(XL1Places.femto)
    public static let atto: BigInt = BigInt(1)
}

/// The maximum value for a given denomination: `10^(32 - places) - 1`.
public func xl1MaxValue(_ places: Int) -> BigInt {
    return BigInt(10).power(32 - places) - 1
}
