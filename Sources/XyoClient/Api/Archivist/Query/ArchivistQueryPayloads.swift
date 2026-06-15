import Foundation

/// Archivist query payloads (`network.xyo.query.archivist.*`), matching the Android
/// `archivist/wrapper/*QueryPayload` classes and the authoritative JS schemas.

public final class ArchivistInsertQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.insert"
    public init() { super.init(ArchivistInsertQueryPayload.schema) }
    enum CodingKeys: String, CodingKey { case schema }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
    }
}

public final class ArchivistGetQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.get"
    public let hashes: [String]
    public init(hashes: [String]) {
        self.hashes = hashes
        super.init(ArchivistGetQueryPayload.schema)
    }
    enum CodingKeys: String, CodingKey { case schema, hashes }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        try container.encode(hashes, forKey: .hashes)
    }
}

public final class ArchivistDeleteQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.delete"
    public let hashes: [String]
    public init(hashes: [String]) {
        self.hashes = hashes
        super.init(ArchivistDeleteQueryPayload.schema)
    }
    enum CodingKeys: String, CodingKey { case schema, hashes }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        try container.encode(hashes, forKey: .hashes)
    }
}

public final class ArchivistAllQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.all"
    public init() { super.init(ArchivistAllQueryPayload.schema) }
    enum CodingKeys: String, CodingKey { case schema }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
    }
}

public final class ArchivistClearQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.clear"
    public init() { super.init(ArchivistClearQueryPayload.schema) }
    enum CodingKeys: String, CodingKey { case schema }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
    }
}

public final class ArchivistNextQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.next"
    public let cursor: String?
    public let limit: Int?
    public let open: Bool?
    public let order: String?
    public init(cursor: String? = nil, limit: Int? = nil, open: Bool? = nil, order: String? = nil) {
        self.cursor = cursor
        self.limit = limit
        self.open = open
        self.order = order
        super.init(ArchivistNextQueryPayload.schema)
    }
    enum CodingKeys: String, CodingKey { case schema, cursor, limit, open, order }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        try container.encodeIfPresent(cursor, forKey: .cursor)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(open, forKey: .open)
        try container.encodeIfPresent(order, forKey: .order)
    }
}

public final class ArchivistCommitQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.commit"
    public init() { super.init(ArchivistCommitQueryPayload.schema) }
    enum CodingKeys: String, CodingKey { case schema }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
    }
}

public final class ArchivistSnapshotQueryPayload: EncodablePayloadInstance {
    public static let schema = "network.xyo.query.archivist.snapshot"
    public init() { super.init(ArchivistSnapshotQueryPayload.schema) }
    enum CodingKeys: String, CodingKey { case schema }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
    }
}
