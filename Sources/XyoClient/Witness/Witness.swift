public protocol WitnessSync {
    func observe() -> [EncodablePayload]
}

public protocol WitnessAsync {
    func observe(completion: @escaping ([EncodablePayload]?, Error?) -> Void)

    @available(iOS 15, *)
    func observe() async throws -> [EncodablePayload]
}
