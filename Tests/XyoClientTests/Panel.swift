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
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    let address = XyoAddress()
    let witness = AbstractWitness(account: address)
    let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
    XCTAssertNotNil(address)
    XCTAssertNotNil(panel)
  }

  func testPanelReport() throws {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    _ = XyoAddress()
    let witness = XyoBasicWitness(observer: {
      let payload = XyoPayload("network.xyo.basic")
      return payload
    })
    let panel = XyoPanel(
      archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])
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
    let panel = XyoPanel {
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
