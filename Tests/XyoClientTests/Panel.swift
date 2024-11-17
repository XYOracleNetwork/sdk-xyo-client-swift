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
        let apiDomain = XyoPanel.Defaults.apiDomain
        let archive = XyoPanel.Defaults.apiModule
        let account = Account()
        let witness = WitnessModuleSync(account: account)
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
        XCTAssertNotNil(account)
        XCTAssertNotNil(panel)
    }

    @available(iOS 15, *)
    func testSimplePanelReport() async {
        let panel = XyoPanel {
            return nil
        }
        let result = await panel.reportQuery()
        XCTAssertTrue(result.payloads.isEmpty, "Expected empty result from report")
    }
    @available(iOS 15, *)
    func testSingleWitnessPanel() async {
        let apiDomain = XyoPanel.Defaults.apiDomain
        let archive = XyoPanel.Defaults.apiModule
        let panel = XyoPanel(
            archive: archive,
            apiDomain: apiDomain,
            witnesses: [
                BasicWitness(observer: {
                    return Payload("network.xyo.basic")
                })
            ]
        )
        let result = await panel.reportQuery()
        XCTAssertFalse(result.payloads.isEmpty, "Expected non-empty result from report")
        XCTAssertEqual(result.payloads.count, 1, "Expected one payload in the result")
    }
    @available(iOS 15, *)
    func testMultiWitnessPanel() async {
        let apiDomain = XyoPanel.Defaults.apiDomain
        let archive = XyoPanel.Defaults.apiModule
        let panel = XyoPanel(
            archive: archive,
            apiDomain: apiDomain,
            witnesses: [
                BasicWitness(observer: {
                    return Payload("network.xyo.basic")
                }),
                SystemInfoWitness(),
            ]
        )
        let result = await panel.reportQuery()
        XCTAssertFalse(result.payloads.isEmpty, "Expected non-empty result from report")
        XCTAssertEqual(result.payloads.count, 2, "Expected two payloads in the result")
    }
}
