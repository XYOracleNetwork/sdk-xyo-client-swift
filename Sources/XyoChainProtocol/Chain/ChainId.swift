import Foundation

/// A chain identifier (hex string), matching the Android `ChainId` typealias.
public typealias ChainId = String

/// A hex string value.
public typealias Hex = String

/// A block number on an XL1 chain.
public struct XL1BlockNumber: Comparable, Equatable, Hashable, CustomStringConvertible {
    public let value: Int64

    public init(_ value: Int64) {
        self.value = value
    }

    public static func < (lhs: XL1BlockNumber, rhs: XL1BlockNumber) -> Bool {
        lhs.value < rhs.value
    }

    public var description: String { String(value) }
}
