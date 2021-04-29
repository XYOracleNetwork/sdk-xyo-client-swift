import Foundation

extension String {
  func sha256() -> String {
    if let stringData = data(using: String.Encoding.utf8) {
      return stringData.sha256()
    }
    return ""
  }
}
