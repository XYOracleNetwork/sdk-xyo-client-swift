import XCTest
@testable import sdk_xyo_client_swift

class TestPayload1SubObject: Codable {
  var numberValue = 2
  var stringValue = "yo"
}

class TestPayload1 : Codable, XyoPayloadJsonProtocol {
  var _timestamp = 1618603439107
  var _schema = "network.xyo.test"
  var numberField = 1
  var objectField = TestPayload1SubObject()
  var stringField = "there"
}

class TestPayload2SubObject: Codable {
  var stringValue = "yo"
  var numberValue = 2
}

class TestPayload2 : Codable, XyoPayloadJsonProtocol {
  var _schema = "network.xyo.test"
  var stringField = "there"
  var objectField = TestPayload1SubObject()
  var _timestamp = 1618603439107
  var numberField = 1
}

var knownHash = "a4cb8ff16e9a0367b5a8dce2a8934f1fca89a786499d27944795ff06ab6c1536"

final class sdk_xyo_client_swiftTests: XCTestCase {
  func testNotAuthenticated() {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    XCTAssertEqual(api.authenticated, false)
  }
  
  func testPayload1() throws {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    let bw = BoundWitnessBuilder().witness("1234567890").payload(TestPayload1())
    let apiExpectation = expectation(description: "API Call")
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash == knownHash, true)
    api.postBoundWitness(bwJson) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json == 1, true)
      apiExpectation.fulfill()
    }
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testPayload2() throws {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    let bw = BoundWitnessBuilder().witness("1234567890").payload(TestPayload2())
    let apiExpectation = expectation(description: "API Call")
    let bwJson = try bw.build()
    XCTAssertEqual(bwJson._hash == knownHash, true)
    api.postBoundWitness(bwJson) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json == 1, true)
      apiExpectation.fulfill()
    }
    waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
    }
  }
  
  static var allTests = [
    ("testNotAuthenticated", testNotAuthenticated),
    ("testPayload1", testPayload1),
    ("testPayload2", testPayload2),
  ]
}
