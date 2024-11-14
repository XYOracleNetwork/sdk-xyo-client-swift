import Foundation

enum ExtendedStringError: Error {
    case sha256HashFailure
}

extension String {
    enum ExtendedEncoding {
        case hexadecimal
    }

    func sha256() throws -> Data {
        if let stringData = data(using: String.Encoding.utf8) {
            return stringData.sha256() as Data
        }
        throw ExtendedStringError.sha256HashFailure
    }

    func keccak256() throws -> Data {
        if let stringData = data(using: String.Encoding.utf8) {
            return stringData.keccak256()
        }
        throw ExtendedStringError.sha256HashFailure
    }

    func data(using encoding: ExtendedEncoding) -> Data? {
        let hexStr = self.dropFirst(self.hasPrefix("0x") ? 2 : 0)

        guard hexStr.count % 2 == 0 else { return nil }

        var newData = Data(capacity: hexStr.count / 2)

        var indexIsEven = true
        for i in hexStr.indices {
            if indexIsEven {
                let byteRange = i...hexStr.index(after: i)
                guard let byte = UInt8(hexStr[byteRange], radix: 16) else { return nil }
                newData.append(byte)
            }
            indexIsEven.toggle()
        }
        return newData
    }

    func hexToData() -> Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(
            in: self, options: [], range: NSRange(location: 0, length: self.count)
        ) {
            match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard !data.isEmpty else {
            return nil
        }

        return data
    }
}
