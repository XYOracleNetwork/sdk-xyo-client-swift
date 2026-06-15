import BigInt
import XCTest
import XyoClient

@testable import XyoChainProtocol

/// Offline tests for the XL1 transaction builder: script generation, fee normalization, payload
/// hashes, and signature verification over the reconstructed signable bound witness.
final class TransactionBuilderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Account.previousHashStore = MemoryPreviousHashStore()
    }

    func test_buildTransaction() throws {
        let signer = try Account.fromPrivateKey(
            "7f71bc5644f8f521f7e9b73f7a391e82c05432f8a9d36c44d6b1edbf1d8db62f")
        let transfer = TransferPayload(transfers: ["5e7a847447e7fec41011ae7d32d768f86605ba03": "0x64"])
        let fees = TransactionFeesBigInt(
            base: BigInt(1), gasLimit: BigInt(21000), gasPrice: BigInt(2), priority: BigInt(0))

        let transaction = try TransactionBuilder()
            .chain("0xabc")
            .fees(fees)
            .range(nbf: 100, exp: 200)
            .payload(transfer)
            .signer(signer)
            .build()

        let bw = transaction.boundWitness
        let transferHash = try PayloadBuilder.dataHash(from: transfer).toHex()

        XCTAssertEqual(bw.payload_hashes, [transferHash])
        XCTAssertEqual(bw.script, ["elevate|\(transferHash)"])
        XCTAssertEqual(bw.payload_schemas, [TransferPayload.schema])

        // Fees are normalized (no 0x prefix) on the wire.
        XCTAssertFalse(bw.fees.base.hasPrefix("0x"))
        XCTAssertEqual(bw.fees.gasLimit, String(BigInt(21000), radix: 16))  // "5208"

        // `from` defaults to the first signer's address.
        XCTAssertEqual(bw.from, signer.address?.toHex())
        XCTAssertEqual(bw.addresses, [signer.address?.toHex()])

        // The signature verifies over the reconstructed signable data hash.
        let signable = SignableTransactionBoundWitness(
            from: bw.from, chain: bw.chain, nbf: bw.nbf, exp: bw.exp, fees: bw.fees,
            script: bw.script, addresses: bw.addresses, payload_hashes: bw.payload_hashes,
            payload_schemas: bw.payload_schemas, previous_hashes: bw.previous_hashes,
            timestamp: bw.timestamp)
        let dataHash = try PayloadBuilder.dataHash(from: signable)
        let signature = try XCTUnwrap(bw.signatures?.first)
        let signatureData = try XCTUnwrap(Data(signature))
        XCTAssertTrue(signer.verify(dataHash, signatureData), "transaction signature must verify")
    }
}
