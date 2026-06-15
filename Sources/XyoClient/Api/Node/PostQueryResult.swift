import Foundation

/// Result of POSTing a query to a node: a parsed `QueryResponse` on success, or the errors that
/// occurred. Mirrors the Android `PostQueryResult`.
public final class PostQueryResult {
    public let response: QueryResponse?
    public let errors: [Error]?

    public init(response: QueryResponse?, errors: [Error]?) {
        self.response = response
        self.errors = errors
    }
}
