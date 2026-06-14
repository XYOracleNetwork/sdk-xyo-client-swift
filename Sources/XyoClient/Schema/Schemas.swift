import Foundation

/// Core protocol schema constants, matching the XYO Yellow Paper Section 7 and the
/// Android SDK's `Schemas.kt`.
public enum Schemas {

    // Core protocol schemas - Section 7.1
    public static let payload = "network.xyo.payload"
    public static let boundWitness = "network.xyo.boundwitness"
    public static let moduleError = "network.xyo.error.module"
    public static let payloadBundle = "network.xyo.payload.bundle"
    public static let payloadSet = "network.xyo.payload.set"

    // Module config schemas - Section 7.2
    public static let moduleConfig = "network.xyo.module.config"
    public static let archivistConfig = "network.xyo.archivist.config"
    public static let divinerConfig = "network.xyo.diviner.config"
    public static let witnessConfig = "network.xyo.witness.config"
    public static let sentinelConfig = "network.xyo.sentinel.config"
    public static let bridgeConfig = "network.xyo.bridge.config"
    public static let nodeConfig = "network.xyo.node.config"

    // Module payload schemas - Section 7.3
    public static let address = "network.xyo.address"
    public static let addressChild = "network.xyo.address.child"
    public static let addressHashPrevious = "network.xyo.address.hash.previous"
    public static let moduleDescription = "network.xyo.module.description"
    public static let moduleState = "network.xyo.module.state"

    // Manifest schemas - Section 7.4
    public static let manifestPackage = "network.xyo.manifest.package"
    public static let manifestPackageDapp = "network.xyo.manifest.package.dapp"
    public static let moduleManifest = "network.xyo.module.manifest"
    public static let nodeManifest = "network.xyo.node.manifest"

    // Module filter/certification - Section 7.3
    public static let moduleFilter = "network.xyo.module.filter"
    public static let childCertification = "network.xyo.child.certification"
    public static let archivistSnapshot = "network.xyo.archivist.snapshot"
    public static let archivistStats = "network.xyo.archivist.stats"

    // Diviner type schemas - Section 7.5
    public static let divinerPayload = "network.xyo.diviner.payload"
    public static let divinerBoundWitness = "network.xyo.diviner.boundwitness"
    public static let divinerAddressHistory = "network.xyo.diviner.address.history"
    public static let divinerAddressChain = "network.xyo.diviner.address.chain"
    public static let divinerAddressSpace = "network.xyo.diviner.address.space"
    public static let divinerTransform = "network.xyo.diviner.transform"
    public static let divinerForecasting = "network.xyo.diviner.forecasting"
    public static let divinerJsonPath = "network.xyo.diviner.jsonpath"
    public static let divinerJsonPathAggregate = "network.xyo.diviner.jsonpath.aggregate"
    public static let divinerJsonPatch = "network.xyo.diviner.jsonpatch"
    public static let divinerIndexing = "network.xyo.diviner.indexing"
    public static let divinerPayloadPointer = "network.xyo.diviner.payload.pointer"
    public static let divinerSchemaList = "network.xyo.diviner.schema.list"
    public static let divinerBoundWitnessStats = "network.xyo.diviner.boundwitness.stats"
    public static let divinerPayloadStats = "network.xyo.diviner.payload.stats"
    public static let divinerSchemaStats = "network.xyo.diviner.schema.stats"

    // Automation schemas - Section 7.6
    public static let automation = "network.xyo.automation"
    public static let automationInterval = "network.xyo.automation.interval"
    public static let automationEventModule = "network.xyo.automation.event.module"

    // Data schemas - Section 7.7
    public static let id = "network.xyo.id"
    public static let value = "network.xyo.value"
    public static let range = "network.xyo.range"
    public static let number = "network.xyo.number"
    public static let bigint = "network.xyo.bigint"

    // Additional payload-type plugin schemas
    public static let config = "network.xyo.config"
    public static let domain = "network.xyo.domain"
    public static let schema = "network.xyo.schema"
}
