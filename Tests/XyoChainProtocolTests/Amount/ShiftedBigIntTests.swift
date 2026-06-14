import BigInt
import XCTest

@testable import XyoChainProtocol

/// Locks the `ShiftedBigInt`/`XL1Amount` formatting behavior (en_US). There are no cross-SDK
/// vectors for formatting, so these assert the documented Android-aligned behavior directly.
final class ShiftedBigIntTests: XCTestCase {

    func test_oneXL1_fullAndShort() {
        let amount = XL1Amount.fromXL1(XL1(1))
        XCTAssertEqual(amount.toFullString(places: XL1Places.xl1), "1.000000000000000000")
        XCTAssertEqual(amount.toString(places: XL1Places.xl1), "1.0")
        XCTAssertEqual(amount.xl1.value, BigInt(1))
    }

    func test_fractionalXL1_floorTruncates() {
        // 1.5 XL1 = 1_500_000_000_000_000_000 atto
        let amount = XL1Amount.fromAtto(BigInt(15) * BigInt(10).power(17))
        XCTAssertEqual(amount.toFullString(places: XL1Places.xl1), "1.500000000000000000")
        XCTAssertEqual(amount.toString(places: XL1Places.xl1), "1.5")
    }

    func test_grouping_thousands() {
        let amount = XL1Amount.fromXL1(XL1(1234))
        XCTAssertEqual(amount.toString(places: XL1Places.xl1), "1,234.0")
    }

    func test_zeroPlaces_integerGrouping() {
        // places = 0 renders the raw integer with grouping.
        let formatted = ShiftedBigInt(
            BigInt(1_234_567), config: ShiftedBigIntConfig(places: 0)
        ).toShortString()
        XCTAssertEqual(formatted, "1,234,567")
    }
}
