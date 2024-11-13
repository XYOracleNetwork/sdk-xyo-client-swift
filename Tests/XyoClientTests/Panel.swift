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
    let account = Account()
    let witness = AbstractWitness(account: account)
    let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
    XCTAssertNotNil(account)
    XCTAssertNotNil(panel)
  }

  func testAsyncReport() async {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    _ = XyoAddress()
    let witness = XyoBasicWitness(observer: {
      let payload = XyoPayload("network.xyo.basic")
      return payload
    })
    let panel = XyoPanel(
      archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])

    do {
      let result = try await panel.report()
      XCTAssertTrue(result.isEmpty, "Expected empty result from report for readonly SDK")

      // TODO: Deserialize the response
      // XCTAssertFalse(result.isEmpty, "Expected non-empty result from report")
      // XCTAssertEqual(result.count, 1, "Expected one payload in the result")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }

  func testPanelReport() async {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    _ = XyoAddress()
    let witness = XyoBasicWitness(observer: {
      let payload = XyoPayload("network.xyo.basic")
      return payload
    })
    let panel = XyoPanel(
      archive: archive, apiDomain: apiDomain, witnesses: [witness, XyoSystemInfoWitness()])
    do {
      let result = try await panel.report()
      XCTAssertTrue(result.isEmpty, "Expected empty result from report for readonly SDK")

      // TODO: Deserialize the response
      // XCTAssertFalse(result.isEmpty, "Expected non-empty result from report")
      // XCTAssertEqual(result.count, 1, "Expected one payload in the result")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }

  func testSimplePanelReport() async {
    let panel = XyoPanel {
      return nil
    }
    do {
      let result = try await panel.report()
      XCTAssertTrue(result.isEmpty, "Expected empty result from report for readonly SDK")

      // TODO: Deserialize the response
      // XCTAssertFalse(result.isEmpty, "Expected non-empty result from report")
      // XCTAssertEqual(result.count, 1, "Expected one payload in the result")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }
}
