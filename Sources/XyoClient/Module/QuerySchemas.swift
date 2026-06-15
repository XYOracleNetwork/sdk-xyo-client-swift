import Foundation

/// Standard query schema constants (XYO Yellow Paper Section 6.5), matching the Android
/// `QuerySchemas`.
public enum QuerySchemas {
    // Module (base) queries
    public static let moduleManifest = "network.xyo.query.module.manifest"
    public static let moduleAddress = "network.xyo.query.module.address"
    public static let moduleState = "network.xyo.query.module.state"
    public static let moduleSubscribe = "network.xyo.query.module.subscribe"

    // Archivist queries
    public static let archivistInsert = "network.xyo.query.archivist.insert"
    public static let archivistGet = "network.xyo.query.archivist.get"
    public static let archivistDelete = "network.xyo.query.archivist.delete"
    public static let archivistAll = "network.xyo.query.archivist.all"
    public static let archivistClear = "network.xyo.query.archivist.clear"
    public static let archivistCommit = "network.xyo.query.archivist.commit"
    public static let archivistSnapshot = "network.xyo.query.archivist.snapshot"
    public static let archivistNext = "network.xyo.query.archivist.next"

    // Diviner queries
    public static let divinerDivine = "network.xyo.query.diviner.divine"

    // Witness queries
    public static let witnessObserve = "network.xyo.query.witness.observe"

    // Sentinel queries
    public static let sentinelReport = "network.xyo.query.sentinel.report"

    // Bridge queries
    public static let bridgeConnect = "network.xyo.query.bridge.connect"
    public static let bridgeDisconnect = "network.xyo.query.bridge.disconnect"
    public static let bridgeExpose = "network.xyo.query.bridge.expose"
    public static let bridgeUnexpose = "network.xyo.query.bridge.unexpose"

    // Node queries
    public static let nodeAttach = "network.xyo.query.node.attach"
    public static let nodeDetach = "network.xyo.query.node.detach"
    public static let nodeCertify = "network.xyo.query.node.certify"
    public static let nodeAttached = "network.xyo.query.node.attached"
    public static let nodeRegistered = "network.xyo.query.node.registered"
}
