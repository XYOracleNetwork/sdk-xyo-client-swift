public protocol Witness {
    func observe() -> [XyoPayload]
}

public protocol WitnessAsync {
    func observe(completion: @escaping ([XyoPayload]?, Error?) -> Void)

    @available(iOS 15, *)
    func observe() async throws -> [XyoPayload]
}
