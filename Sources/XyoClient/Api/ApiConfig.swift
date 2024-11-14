public class ApiConfig {
    var apiDomain: String
    var token: String?

    public init(_ apiDomain: String, _ token: String? = nil) {
        self.apiDomain = apiDomain
        self.token = token
    }
}
