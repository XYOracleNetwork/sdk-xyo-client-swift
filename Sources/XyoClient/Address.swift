import Foundation
import CryptoKit

enum XyoAddressError: Error {
  case invalidPrivateKey
  case invalidPrivateKeyLength
}

@available(iOS 13.0, *)
@available(OSX 10.15, *)

public class XyoAddress {
  
  private var _privateKey: Curve25519.Signing.PrivateKey?
  
  public var privateKey: String? {
    get {
      return self._privateKey?.rawRepresentation.toHex()
    }
  }
  
  public var publicKey: String? {
    get {
      return self._privateKey?.publicKey.rawRepresentation.toHex()
    }
  }
  
  public init() throws {
    if let generatedPrivateKey = try self.generatePrivateKey() {
      self._privateKey = generatedPrivateKey
    }
  }
  
  public init(key: Data) throws {
    if let generatedPrivateKey = try self.generatePrivateKey(key) {
      self._privateKey = generatedPrivateKey
    }
  }
  
  public init(key: String) throws {
    if let keyData = key.data(using: .hexadecimal) {
      if let generatedPrivateKey = try self.generatePrivateKey(keyData) {
        self._privateKey = generatedPrivateKey
      }
    }
  }
  
  public convenience init(phrase: String) throws {
    if let key = phrase.data(using: String.Encoding.utf8)?.sha256() {
      try self.init(key: key as Data)
    } else {
      throw XyoAddressError.invalidPrivateKey
    }
  }
  
  private func generatePrivateKey() throws -> Curve25519.Signing.PrivateKey? {
    return Curve25519.Signing.PrivateKey()
  }
  
  private func generatePrivateKey(_ privateKey: Data) throws -> Curve25519.Signing.PrivateKey? {
    if (privateKey.count == 64) {
      throw XyoAddressError.invalidPrivateKeyLength
    }
    do {
      return try Curve25519.Signing.PrivateKey(rawRepresentation: privateKey)
    } catch {
      throw XyoAddressError.invalidPrivateKey
    }
  }
}
