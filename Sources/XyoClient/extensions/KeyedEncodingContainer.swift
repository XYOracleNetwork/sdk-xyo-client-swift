extension KeyedEncodingContainer {
    mutating func encodeIfValidNumeric<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    where T: BinaryFloatingPoint & Encodable {
        if let value = value, !value.isNaN {
            try encode(value, forKey: key)
        }
    }
    mutating func encodeIfNotNil<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key) throws
    where T: Encodable {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}
