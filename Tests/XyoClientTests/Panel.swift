import XCTest
@testable import XyoClient

@available(iOS 13.0, *)
final class PanelTests: XCTestCase {
    static var allTests = [
        ("createPanel", testCreatePanel,
         "panelReport", testPanelReport,
         "simplePanelReport", testSimplePanelReport
         )
    ]
    
    func testCreatePanel() throws {
        let apiDomain = "https://beta.api.archivist.xyo.network"
        let archive = "temp"
        let address = XyoAddress()
        let witness = XyoWitness(address)
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
        XCTAssertNotNil(address)
        XCTAssertNotNil(panel)
    }
    
    func testPanelReport() throws {
        let apiDomain = "https://beta.api.archivist.xyo.network"
        let archive = "temp"
        _ = XyoAddress()
        let witness = XyoBasicWitness({ previousHash in
            let payload = XyoPayload("network.xyo.basic")
            return payload
        })
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])
        let panelExpectation = expectation(description: "Panel Report")
        try panel.report { errors in
            XCTAssertEqual(errors.count,  0)
            panelExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSimplePanelReport() throws {
        let panel = XyoPanel { previousHash in
            return nil
        }
        let panelExpectation = expectation(description: "Panel Report")
        try panel.report { errors in
            XCTAssertEqual(errors.count,  0)
            panelExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testReportEvent() throws {
        let panel = XyoPanel(witnesses: [XyoSystemInfoWitness()])
        let panelExpectation = expectation(description: "Panel Report")
        try panel.event("test_event") { errors in
            XCTAssertEqual(errors.count,  0)
            panelExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
}
