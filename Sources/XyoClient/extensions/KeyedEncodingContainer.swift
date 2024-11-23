extension KeyedEncodingContainer {
    mutating func encodeIfValidNumeric<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    where T: BinaryFloatingPoint & Encodable {
        if let value = value, !value.isNaN {
            try encodeIfPresent(value, forKey: key)
        }
    }
}
