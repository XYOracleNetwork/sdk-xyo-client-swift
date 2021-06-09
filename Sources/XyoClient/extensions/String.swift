import Foundation

enum ExtendedStringError: Error {
    case sha256HashFailure
}

extension String {
    enum ExtendedEncoding {
        case hexadecimal
    }
    func sha256() throws -> String {
        if let stringData = data(using: String.Encoding.utf8) {
            return stringData.sha256String()
        }
        throw ExtendedStringError.sha256HashFailure
    }
    func data(using encoding:ExtendedEncoding) -> Data? {
        let hexStr = self.dropFirst(self.hasPrefix("0x") ? 2 : 0)
        
        guard hexStr.count % 2 == 0 else { return nil }
        
        var newData = Data(capacity: hexStr.count/2)
        
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
    
}
