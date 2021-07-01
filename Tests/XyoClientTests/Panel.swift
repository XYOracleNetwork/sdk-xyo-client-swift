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
        let apiDomain = "https://beta.archivist.xyo.network"
        let archive = "test"
        let address = try XyoAddress()
        let witness = XyoWitness(address)
        let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
        XCTAssertNotNil(address)
        XCTAssertNotNil(panel)
    }
    
    func testPanelReport() throws {
        let apiDomain = "https://beta.archivist.xyo.network"
        let archive = "test"
        _ = try XyoAddress()
        let witness = try XyoBasicWitness({ previousHash in
            let payload = XyoBasicPayload()
            return payload
        })
        let panel = try XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])
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
}
