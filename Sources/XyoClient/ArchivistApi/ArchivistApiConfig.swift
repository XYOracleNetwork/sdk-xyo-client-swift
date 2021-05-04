public class XyoArchivistApiConfig: XyoApiConfig {
    var archive: String
    public init(_ archive: String, _ apiDomain: String, _ token: String? = nil) {
        self.archive = archive
        super.init(apiDomain, token)
    }
}
