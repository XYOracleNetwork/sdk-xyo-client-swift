import XCTest

@testable import XyoClient

/// Verifies secp256k1 account derivation and RFC6979-deterministic signing against the
/// authoritative JS vectors: private key → uncompressed public key → address, and
/// `sign(messageHash)` → compact 64-byte signature.
final class JsVectorAccountTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Keep signing deterministic — avoid previousHash chaining across signatures.
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_accountVectors() throws {
        let vectors = JsCompatVectors.accounts
        XCTAssertFalse(vectors.isEmpty, "No account vectors loaded")
        for (index, vector) in vectors.enumerated() {
            let privateKey = try XCTUnwrap(vector["private_key"] as? String)
            let expectedPublicKey = try XCTUnwrap(vector["public_key_uncompressed"] as? String)
            let expectedAddress = try XCTUnwrap(vector["address"] as? String)

            let account = try Account.fromPrivateKey(privateKey)

            // `publicKeyUncompressed` carries the 0x04 prefix; the vector omits it (64 bytes).
            let publicKey = try XCTUnwrap(account.publicKeyUncompressed)
            XCTAssertEqual(
                Data(publicKey.dropFirst()).toHex(), expectedPublicKey,
                "public key mismatch for account [\(index)]")
            XCTAssertEqual(
                account.address?.toHex(), expectedAddress,
                "address mismatch for account [\(index)]")

            let signatures = vector["signatures"] as? [[String: Any]] ?? []
            for signatureVector in signatures {
                let messageHash = try XCTUnwrap(signatureVector["message_hash"] as? String)
                let expectedSignature = try XCTUnwrap(signatureVector["signature"] as? String)

                // Fresh account per signature so previousHash state never advances.
                let signer = try Account.fromPrivateKey(privateKey)
                let hashData = try XCTUnwrap(Data(messageHash))
                let signature = try signer.sign(hashData)
                XCTAssertEqual(
                    signature.toHex(), expectedSignature,
                    "signature mismatch for account [\(index)] over \(messageHash)")

                // verify() accepts the authoritative signature and rejects a tampered hash.
                let expectedSignatureData = try XCTUnwrap(Data(expectedSignature))
                XCTAssertTrue(
                    signer.verify(hashData, expectedSignatureData),
                    "verify rejected valid signature for account [\(index)] over \(messageHash)")
                var tampered = [UInt8](hashData)
                tampered[0] ^= 0xFF
                XCTAssertFalse(
                    signer.verify(Data(tampered), expectedSignatureData),
                    "verify accepted a signature over a tampered hash for account [\(index)]")
            }
        }
    }
}
