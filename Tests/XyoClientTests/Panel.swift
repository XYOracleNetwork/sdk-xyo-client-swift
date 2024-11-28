import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class PanelTests: XCTestCase {
    static var allTests = [
        (
            "createPanel", testCreatePanel,
            "simplePanelReport", testSimplePanelReport,
            "singleWitnessPanel", testSingleWitnessPanel,
            "multiWitnessPanel", testMultiWitnessPanel
        )
    ]

    let basicWitness = BasicWitness(observer: {
        return Payload("network.xyo.basic")
    })
    let systemInfoWitness = SystemInfoWitness()

    func testCreatePanel() throws {
        let panel = XyoPanel(witnesses: [basicWitness])
        XCTAssertNotNil(panel)
    }

    @available(iOS 15, *)
    func testSimplePanelReport() async {
        let panel = XyoPanel()
        let result = await panel.reportQuery()
        XCTAssertEqual(result.bw.boundWitness.addresses.count, 1)
        XCTAssertEqual(result.bw.boundWitness.addresses[0], panel.account.address?.toHex())
        XCTAssertTrue(result.payloads.isEmpty, "Expected empty result from panel report")
    }

    @available(iOS 15, *)
    func testSingleWitnessPanel() async {
        let witnesses = [basicWitness]
        let panel = XyoPanel(
            witnesses: [basicWitness]
        )
        let result = await panel.reportQuery()
        XCTAssertEqual(result.bw.boundWitness.addresses.count, 1)
        XCTAssertEqual(result.bw.boundWitness.addresses[0], panel.account.address?.toHex())
        XCTAssertEqual(
            result.payloads.count, witnesses.count,
            "Expected \(witnesses.count) payloads in the panel report result")
    }

    @available(iOS 15, *)
    func testMultiWitnessPanel() async {
        let witnesses = [basicWitness, systemInfoWitness]
        let panel = XyoPanel(
            witnesses: witnesses
        )
        let result = await panel.reportQuery()
        XCTAssertEqual(result.bw.boundWitness.addresses.count, 1)
        XCTAssertEqual(result.bw.boundWitness.addresses[0], panel.account.address?.toHex())
        XCTAssertEqual(
            result.payloads.count, witnesses.count,
            "Expected \(witnesses.count) payloads in the panel report result")
    }
}
