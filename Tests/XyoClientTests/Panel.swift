import XCTest
@testable import XyoClient

@available(iOS 13.0, *)
final class PanelTests: XCTestCase {
    static var allTests = [
        (
            "createPanel", testCreatePanel,
            "panelReport", testPanelReport,
            "simplePanelReport", testSimplePanelReport
        )
    ]
    
    func testCreatePanel() throws {
        let apiDomain = "https://beta.api.archivist.xyo.network"
        let archive = "Archivist"
        let address = XyoAddress()
        let witness = XyoWitness(address)
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
        XCTAssertNotNil(address)
        XCTAssertNotNil(panel)
    }
    
    func testPanelReport() throws {
        let apiDomain = "https://beta.api.archivist.xyo.network"
        let archive = "Archivist"
        _ = XyoAddress()
        let witness = XyoBasicWitness({ _ in
            let payload = XyoPayload("network.xyo.basic")
            return payload
        })
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])
        let panelExpectation = expectation(description: "Panel Report")
        let result = try panel.report { errors in
            XCTAssertEqual(errors.count, 0)
            panelExpectation.fulfill()
        }
        XCTAssertFalse(result.isEmpty)
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSimplePanelReport() throws {
        let panel = XyoPanel { _ in
            return nil
        }
        let panelExpectation = expectation(description: "Panel Report")
        let result = try panel.report { errors in
            XCTAssertEqual(errors.count, 0)
            panelExpectation.fulfill()
        }
        XCTAssertTrue(result.isEmpty)
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testReportEvent() throws {
        let panel = XyoPanel(witnesses: [XyoSystemInfoWitness()])
        let panelExpectation = expectation(description: "Panel Report")
        let result = try panel.event("test_event") { errors in
            XCTAssertEqual(errors.count, 0)
            panelExpectation.fulfill()
        }
        XCTAssertFalse(result.isEmpty)
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
}
