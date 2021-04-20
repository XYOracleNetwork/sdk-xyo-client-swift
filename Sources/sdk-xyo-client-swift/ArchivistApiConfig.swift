class XyoArchivistApiConfig : XyoWorldApiConfig {
  var archive: String
  init(_ archive: String, _ apiDomain: String, _ token: String? = nil, _ userid: String? = nil) {
    self.archive = archive
    super.init(apiDomain, token, userid)
  }
}
