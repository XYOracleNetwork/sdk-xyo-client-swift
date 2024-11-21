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

    func testCreatePanel() throws {
        let account = Account()
        let witness = WitnessModuleSync(account: account)
        let panel = XyoPanel(witnesses: [witness])
        XCTAssertNotNil(account)
        XCTAssertNotNil(panel)
    }

    @available(iOS 15, *)
    func testSimplePanelReport() async {
        let panel = XyoPanel {
            return nil
        }
        let result = await panel.reportQuery()
        XCTAssertTrue(result.payloads.isEmpty, "Expected empty result from panel report")
    }

    @available(iOS 15, *)
    func testSingleWitnessPanel() async {
        let witnesses = [
            BasicWitness(observer: {
                return Payload("network.xyo.basic")
            })
        ]
        let panel = XyoPanel(
            witnesses: witnesses
        )
        let result = await panel.reportQuery()
        XCTAssertEqual(
            result.payloads.count, witnesses.count,
            "Expected \(witnesses.count) payloads in the panel report result")
    }

    @available(iOS 15, *)
    func testMultiWitnessPanel() async {
        let witnesses = [
            BasicWitness(observer: {
                return Payload("network.xyo.basic")
            }),
            SystemInfoWitness(),
        ]
        let panel = XyoPanel(
            witnesses: witnesses
        )
        let result = await panel.reportQuery()
        XCTAssertEqual(
            result.payloads.count, witnesses.count,
            "Expected \(witnesses.count) payloads in the panel report result")
    }
}
