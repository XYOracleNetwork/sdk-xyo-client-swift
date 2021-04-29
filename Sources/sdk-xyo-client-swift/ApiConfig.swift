public class XyoApiConfig {
  var apiDomain: String
  var token: String?
  var userid: String?
  
  public init(_ apiDomain: String, _ token: String? = nil, _ userid: String? = nil) {
    self.apiDomain = apiDomain
    self.token = token
    self.userid = userid
  }
}
