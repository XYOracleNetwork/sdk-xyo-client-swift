import XCTest
import SwiftyJSON
@testable import sdk_xyo_client_swift

var TestPayload1: [String: Any] = [
  "_schema": "network.xyo.test",
  "_timestamp": 1618603439107,
  "numberField": 1,
  "objectField": [
    "numberValue": 2,
    "stringValue": "yo"
  ],
  "stringField": "there"
]

var TestPayload2: [String: Any] = [
  "_schema": "network.xyo.test",
  "stringField": "there",
  "objectField": [
    "numberValue": 2,
    "stringValue": "yo"
  ],
  "_timestamp": 1618603439107,
  "numberField": 1
]

var knownHash = "a4cb8ff16e9a0367b5a8dce2a8934f1fca89a786499d27944795ff06ab6c1536"

final class sdk_xyo_client_swiftTests: XCTestCase {
  func testNotAuthenticated() {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    XCTAssertEqual(api.authenticated, false)
  }
  
  func testPayload1() {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    let bw = BoundWitnessBuilder().witness("1234567890").payload(JSON(TestPayload1))
    debugPrint("hash: \(BoundWitnessBuilder.hash(bw.hashable()))")
    api.postBoundWitness(entries: bw.build()) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json?[0]["_hash"].string == knownHash, true)
    }
  }
  
  func testPayload2() {
    let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
    let api = XyoArchivistApi.get(config)
    let bw = BoundWitnessBuilder().witness("1234567890").payload(JSON(TestPayload2))
    debugPrint("hash: \(BoundWitnessBuilder.hash(bw.hashable()))")
    api.postBoundWitness(entries: bw.build()) { json, error in
      XCTAssertEqual(error == nil, true)
      XCTAssertEqual(json?[0]["_hash"].string == knownHash, true)
    }
  }
  
  static var allTests = [
    ("testNotAuthenticated", testNotAuthenticated),
    ("testPayload1", testPayload1),
    ("testPayload2", testPayload2),
  ]
}
