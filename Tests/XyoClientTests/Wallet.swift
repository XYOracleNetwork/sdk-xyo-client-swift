import XCTest

@testable import XyoClient

struct MasterKeyTestVector: Decodable {
    let hexEncodedSeed: String
    let base58CheckEncodedKey: String
}

class WalletTests: XCTestCase {
    
    let publicMasterKeyTestData: [MasterKeyTestVector] =
    [
        MasterKeyTestVector(
            hexEncodedSeed: "000102030405060708090a0b0c0d0e0f",
            base58CheckEncodedKey: "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"
        ),
        MasterKeyTestVector(
            hexEncodedSeed: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542",
            base58CheckEncodedKey: "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"
        ),
        MasterKeyTestVector(
            hexEncodedSeed: "4b381541583be4423346c643850da4b320e46a87ae3d2a4e6da11eba819cd4acba45d239319ac14f863b8d5ab5a0d0c64d2e8a1e7d1457df2e5a3c51c73235be",
            base58CheckEncodedKey: "xprv9s21ZrQH143K25QhxbucbDDuQ4naNntJRi4KUfWT7xo4EKsHt2QJDu7KXp1A3u7Bi1j8ph3EGsZ9Xvz9dGuVrtHHs7pXeTzjuxBrCmmhgC6"
        ),
        MasterKeyTestVector(
            hexEncodedSeed: "3ddd5602285899a946114506157c7997e5444528f3003f6134712147db19b678",
            base58CheckEncodedKey: "xprv9s21ZrQH143K48vGoLGRPxgo2JNkJ3J3fqkirQC2zVdk5Dgd5w14S7fRDyHH4dWNHUgkvsvNDCkvAwcSHNAQwhwgNMgZhLtQC63zxwhQmRv"
        )
    ]

    func test_generateFromMnemonic() {
        let phrase = "later puppy sound rebuild rebuild noise ozone amazing hope broccoli crystal grief"
        let rootAddress = "e46c258c74c7c1df33d7caa4c2c664dc0843ab3f"
        let rootPrivateKey = "96a7705eedbb701a03ee235911253fd3eb80e48a06106c0bf957d42b72bd8efa"
        let rootEntropy = "7d55c33f59ab352ba7a03e6d638cd533"
        let paths = ["0/4", "44'/0'/0'", "44'/60'/0'/0/0", "44'/60'/0'/0/1", "49'/0'/0'", "84'/0'/0'", "84'/0'/0'/0"]
        let pathAddresses = ["0/4", "44'/0'/0'", "44'/60'/0'/0/0", "44'/60'/0'/0/1", "49'/0'/0'", "84'/0'/0'", "84'/0'/0'/0"]
        
        let words = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        let privateKeyPathVector = "m/44'/0'/0'/0/0"
        let privateKeyVector = "e284129cc0922579a535bbf4d1a3b25773090d28c909bc0fed73b5e0222cc372"
        
        let seedTestVector = "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
        let seedPrivateKeyTestVector = "e8f32e723decf4051aefac8e3b9b3e2458d30c00f8a7b40315fadaf4d3e5e36e"
        let seedRootChainCodeTestVector = "873dff81c02f525623fd1fe518a6e6c8c760b640eb67d2b510ac2b7e39d1e1e4"
        
        let seedTestVectorPrime = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                         0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
                         0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
                         0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F])
        
        do {
            
            let entropy = try Bip39.mnemonicToEntropy(phrase: phrase)
            let seed = try Bip39.entropyToSeed(entropy: entropy)
            let reconstructedMnemonic = try Bip39.entropyToMnemonic(entropy: entropy)
            print("Original Mnemonic: \(phrase)")
            print("Reconstructed Mnemonic: \(reconstructedMnemonic)")
            XCTAssertEqual(phrase, reconstructedMnemonic)
            
            let derivedPrivateKey = try Bip39.rootPrivateKeyFromSeed(seed: seedTestVectorPrime)
            
            XCTAssertEqual(derivedPrivateKey.privateKey.toHex(), seedPrivateKeyTestVector)
            XCTAssertEqual(derivedPrivateKey.chainCode.toHex(), seedRootChainCodeTestVector)
            
            let defaultKey = try Wallet.deriveKey(from: derivedPrivateKey, path: privateKeyPathVector)
            
            XCTAssertEqual(defaultKey.privateKey.toHexString(), privateKeyVector)
            
            let sut = try Wallet(phrase: phrase, path: "m/44'/60'/0'/0/0")
            let sut2 = try Wallet(phrase: phrase, path: "m")
            XCTAssertNotEqual(sut.address, sut2.address)
            let calcedEntropy = try Bip39.mnemonicToEntropy(phrase: phrase)
            let calcedPhrase = try Bip39.entropyToMnemonic(entropy: calcedEntropy)
            
            XCTAssertEqual(phrase, calcedPhrase)
            
            XCTAssertEqual(rootEntropy, calcedEntropy.toHex())
            XCTAssertEqual(sut.privateKey?.toHex(), rootPrivateKey)
            XCTAssertEqual(sut.address?.toHex(), rootAddress)
            
            let sutPath0 = try sut.derivePath(path: paths[0])
            XCTAssertEqual(sutPath0.address?.toHex(), pathAddresses[0])
            
            // Assert
            XCTAssertNil(nil)
        } catch {
            print("Caught error: \(error)")
            XCTAssertTrue(false)
        }
    }
}
