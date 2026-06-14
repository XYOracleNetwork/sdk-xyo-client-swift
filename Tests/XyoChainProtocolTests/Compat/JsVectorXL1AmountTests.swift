import BigInt
import XCTest

@testable import XyoChainProtocol

/// Verifies XL1 denomination conversions against the authoritative JS vectors: given an atto
/// value, every denomination must read exactly as the JS `bigint` division produces.
final class JsVectorXL1AmountTests: XCTestCase {

    func test_xl1AmountVectors() throws {
        let vectors = JsCompatVectors.xl1Amounts
        XCTAssertFalse(vectors.isEmpty, "No xl1_amounts vectors loaded")
        for vector in vectors {
            let label = vector["label"] as? String ?? "<unknown>"
            let atto = try bigInt(vector, "atto", label)
            let amount = XL1Amount.fromAtto(atto)

            XCTAssertEqual(amount.atto.value, atto, "\(label) atto")
            XCTAssertEqual(amount.femto.value, try bigInt(vector, "femto", label), "\(label) femto")
            XCTAssertEqual(amount.pico.value, try bigInt(vector, "pico", label), "\(label) pico")
            XCTAssertEqual(amount.nano.value, try bigInt(vector, "nano", label), "\(label) nano")
            XCTAssertEqual(amount.micro.value, try bigInt(vector, "micro", label), "\(label) micro")
            XCTAssertEqual(amount.milli.value, try bigInt(vector, "milli", label), "\(label) milli")
            XCTAssertEqual(amount.xl1.value, try bigInt(vector, "xl1", label), "\(label) xl1")
        }
    }

    private func bigInt(_ vector: [String: Any], _ key: String, _ label: String) throws -> BigInt {
        let string = try XCTUnwrap(vector[key] as? String, "\(label) missing \(key)")
        return try XCTUnwrap(BigInt(string), "\(label) \(key) not a BigInt: \(string)")
    }
}
