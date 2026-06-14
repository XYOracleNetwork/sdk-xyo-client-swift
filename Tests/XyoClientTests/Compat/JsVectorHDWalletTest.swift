import XCTest

@testable import XyoClient

/// Verifies BIP-44 Ethereum-style HD derivation against the authoritative JS vectors:
/// mnemonic + path → private key / uncompressed public key / address.
final class JsVectorHDWalletTest: XCTestCase {

    override func setUp() {
        super.setUp()
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_hdWalletVectors() throws {
        let groups = JsCompatVectors.hdWallets
        XCTAssertFalse(groups.isEmpty, "No hd_wallet vectors loaded")
        for group in groups {
            let mnemonic = try XCTUnwrap(group["mnemonic"] as? String)
            let derivations = group["derivations"] as? [[String: Any]] ?? []
            for derivation in derivations {
                let path = try XCTUnwrap(derivation["path"] as? String)
                let expectedPrivateKey = try XCTUnwrap(derivation["private_key"] as? String)
                let expectedPublicKey = try XCTUnwrap(derivation["public_key_uncompressed"] as? String)
                let expectedAddress = try XCTUnwrap(derivation["address"] as? String)

                let wallet = try Wallet.fromMnemonic(mnemonic: mnemonic, path: path)
                XCTAssertEqual(
                    wallet.privateKey?.toHex(), expectedPrivateKey,
                    "private key mismatch for \(path)")
                if let publicKey = wallet.publicKeyUncompressed {
                    XCTAssertEqual(
                        Data(publicKey.dropFirst()).toHex(), expectedPublicKey,
                        "public key mismatch for \(path)")
                }
                XCTAssertEqual(
                    wallet.address?.toHex(), expectedAddress,
                    "address mismatch for \(path)")
            }
        }
    }
}
