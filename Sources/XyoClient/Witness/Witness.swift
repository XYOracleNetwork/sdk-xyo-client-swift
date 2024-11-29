public protocol WitnessSync {
    func observe() -> [EncodablePayloadInstance]
}

public protocol WitnessAsync {
    func observe(completion: @escaping ([EncodablePayloadInstance]?, Error?) -> Void)

    @available(iOS 15, *)
    func observe() async throws -> [EncodablePayloadInstance]
}
