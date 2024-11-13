let BoundWitnessSchema = "network.xyo.boundwitness"

public class BoundWitness: XyoPayload, XyoBoundWitnessBodyProtocol, XyoBoundWitnessMetaProtocol {

  public var _client: String? = "swift"

  public var _hash: String? = nil

  public var _signatures: [String?]? = nil

  public var _previous_hash: String? = nil

  public var addresses: [String?] = []

  public var payload_hashes: [String] = []

  public var payload_schemas: [String] = []

  public var previous_hashes: [String?] = []

  init() {
    super.init(BoundWitnessSchema)
  }
}
