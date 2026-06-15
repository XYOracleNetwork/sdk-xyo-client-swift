import BigInt
import Foundation

/// Transaction fees as hex strings, matching the Android `TransactionFeesHex`.
public struct TransactionFeesHex: Codable, Equatable {
    public let base: String
    public let gasLimit: String
    public let gasPrice: String
    public let priority: String

    public init(base: String, gasLimit: String, gasPrice: String, priority: String) {
        self.base = base
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.priority = priority
    }

    public func toBigInt() -> TransactionFeesBigInt { TransactionFeesBigInt.fromHex(self) }

    /// Strip any `0x` prefix from each field (the on-wire/signable form).
    public func normalized() -> TransactionFeesHex {
        TransactionFeesHex(
            base: TransactionFeesHex.strip(base),
            gasLimit: TransactionFeesHex.strip(gasLimit),
            gasPrice: TransactionFeesHex.strip(gasPrice),
            priority: TransactionFeesHex.strip(priority))
    }

    private static func strip(_ value: String) -> String {
        if value.hasPrefix("0x") || value.hasPrefix("0X") { return String(value.dropFirst(2)) }
        return value
    }
}

/// Transaction fees as `BigInt` values, matching the Android `TransactionFeesBigInt`.
public struct TransactionFeesBigInt: Equatable {
    public let base: BigInt
    public let gasLimit: BigInt
    public let gasPrice: BigInt
    public let priority: BigInt

    public init(base: BigInt, gasLimit: BigInt, gasPrice: BigInt, priority: BigInt) {
        self.base = base
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.priority = priority
    }

    public func toHex() -> TransactionFeesHex {
        TransactionFeesHex(
            base: "0x" + String(base, radix: 16),
            gasLimit: "0x" + String(gasLimit, radix: 16),
            gasPrice: "0x" + String(gasPrice, radix: 16),
            priority: "0x" + String(priority, radix: 16))
    }

    public static func fromHex(_ hex: TransactionFeesHex) -> TransactionFeesBigInt {
        TransactionFeesBigInt(
            base: parse(hex.base),
            gasLimit: parse(hex.gasLimit),
            gasPrice: parse(hex.gasPrice),
            priority: parse(hex.priority))
    }

    private static func parse(_ value: String) -> BigInt {
        let clean = value.hasPrefix("0x") || value.hasPrefix("0X") ? String(value.dropFirst(2)) : value
        return BigInt(clean, radix: 16) ?? BigInt(0)
    }
}
