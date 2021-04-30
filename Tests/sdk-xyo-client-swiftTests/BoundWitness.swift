import XCTest
@testable import sdk_xyo_client_swift

class TestPayload1SubObject: Codable {
  var numberValue = 2
  var stringValue = "yo"
}

class TestPayload1: Codable {
  var timestamp = 1618603439107
  var numberField = 1
  var objectField = TestPayload1SubObject()
  var stringField = "there"
}

class TestPayload2SubObject: Codable {
  var stringValue = "yo"
  var numberValue = 2
}

class TestPayload2: Codable {
  var stringField = "there"
  var objectField = TestPayload1SubObject()
  var timestamp = 1618603439107
  var numberField = 1
}

var knownHash = "d684819b68a8e2f5b5ecf6292cef1e4b9ef4a6dc6a3606a6b19c4d92f48eba54"

@available(iOS 13.0, *)
final class BoundWitnessTests: XCTestCase {
  static var allTests = [
    ("testNotAuthenticated", testNotAuthenticated),
    ("testPayload1", testPayload1),
    ("testPayload2", testPayload2),
    ("testPayload1", testPayload1WithSend),
    ("testPayload2", testPayload2WithSend)
  ]
  
  func testNotAuthenticated() {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApiClient.get(config)
    XCTAssertEqual(api.authenticated, false)
  }
  
  func testPayload1() throws {
    let bw = try BoundWitnessBuilder().witness("1234567890").payload("network.xyo.test", TestPayload1())
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash, knownHash)
  }
  
  func testPayload1WithSend() throws {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApiClient.get(config)
    let bw = try BoundWitnessBuilder().witness("1234567890").payload("network.xyo.test", TestPayload1())
    let apiExpectation = expectation(description: "API Call")
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash, knownHash)
    try api.postBoundWitness(bwJson) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json == 1, true)
      apiExpectation.fulfill()
    }
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testPayload2() throws {
    let bw = try BoundWitnessBuilder().witness("1234567890").payload("network.xyo.test", TestPayload2())
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash, knownHash)
  }
  
  func testPayload2WithSend() throws {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApiClient.get(config)
    let bw = try BoundWitnessBuilder().witness("1234567890").payload("network.xyo.test", TestPayload2())
    let apiExpectation = expectation(description: "API Call")
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash, knownHash)
    try api.postBoundWitness(bwJson) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json == 1, true)
      apiExpectation.fulfill()
    }
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
    }
  }
}
