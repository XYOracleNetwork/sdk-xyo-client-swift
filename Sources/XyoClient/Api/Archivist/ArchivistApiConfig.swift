public class XyoArchivistApiConfig: ApiConfig {
    var apiModule: String
    public init(_ apiModule: String, _ apiDomain: String, _ token: String? = nil) {
        self.apiModule = apiModule
        super.init(apiDomain, token)
    }
}
