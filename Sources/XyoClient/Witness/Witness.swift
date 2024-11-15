public protocol WitnessSync {
    func observe() -> [Payload]
}

public protocol WitnessAsync {
    func observe(completion: @escaping ([Payload]?, Error?) -> Void)

    @available(iOS 15, *)
    func observe() async throws -> [Payload]
}
