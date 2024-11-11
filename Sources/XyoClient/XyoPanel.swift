import Foundation

public enum XyoPanelError: Error {
  case postToArchivistFailed
}

public class XyoPanel {

  public init(archivists: [XyoArchivistApiClient], witnesses: [AbstractWitness]) {
    self._archivists = archivists
    self._witnesses = witnesses
  }

  public convenience init(
    archive: String? = nil, apiDomain: String? = nil, witnesses: [AbstractWitness]? = nil,
    token: String? = nil
  ) {
    let apiConfig = XyoArchivistApiConfig(
      archive ?? XyoPanel.Defaults.apiModule, apiDomain ?? XyoPanel.Defaults.apiDomain)
    let archivist = XyoArchivistApiClient.get(apiConfig)
    self.init(archivists: [archivist], witnesses: witnesses ?? [])
  }

  public convenience init(observe: (() -> XyoEventPayload?)?) {
    if observe != nil {
      var witnesses = [AbstractWitness]()

      if let observe = observe {
        witnesses.append(XyoEventWitness(observe))
      }

      self.init(witnesses: witnesses)
    } else {
      self.init()
    }
  }

  public typealias XyoPanelReportCallback = (([String]) -> Void)

  private var _archivists: [XyoArchivistApiClient]
  private var _witnesses: [AbstractWitness]
  private var _previous_hash: String?

  public func report() throws -> [XyoPayload] {
    try report(nil)
  }

  public func event(_ event: String, _ closure: XyoPanelReportCallback?) throws -> [XyoPayload] {
    try report([XyoEventWitness { XyoEventPayload(event) }], closure)
  }

  public func report(
    _ adhocWitnesses: [AbstractWitness], _ closure: XyoPanelReportCallback?
  ) throws
    -> [XyoPayload]
  {
    var witnesses: [AbstractWitness] = []
    witnesses.append(contentsOf: adhocWitnesses)
    witnesses.append(contentsOf: self._witnesses)
    let payloads = witnesses.map { witness in
      witness.observe()
    }.flatMap({ $0 })
    let (bw, _) = try BoundWitnessBuilder()
      .payloads(payloads)
      .signers(witnesses.map({ $0.account }))
      .build(_previous_hash)
    self._previous_hash = bw._hash
    var errors: [String] = []
    var archivistCount = _archivists.count
    try _archivists.forEach { archivist in
      try archivist.postBoundWitness(bw) { error in
        archivistCount = archivistCount - 1
        if let errorExists = error {
          errors.append(errorExists)
        }
        if archivistCount == 0 {
          closure?(errors)
        }
      }
    }
    return payloads.compactMap { $0 }
  }

  public func report(_ closure: XyoPanelReportCallback?) throws -> [XyoPayload] {
    return try self.report([], closure)
  }

  struct Defaults {
    static let apiDomain =
      ProcessInfo.processInfo.environment["XYO_API_DOMAIN"]
      ?? "https://beta.api.archivist.xyo.network"
    static let apiModule = ProcessInfo.processInfo.environment["XYO_API_MODULE"] ?? "Archivist"
  }

  private static var defaultArchivist: XyoArchivistApiClient {
    XyoArchivistApiClient.get(
      XyoArchivistApiConfig(self.Defaults.apiModule, self.Defaults.apiDomain))
  }
}
