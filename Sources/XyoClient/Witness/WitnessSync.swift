public protocol WitnessProtocol {}


public protocol WitnessSync: WitnessProtocol {
    func observe() -> [Payload]
}

public protocol WitnessAsync: WitnessProtocol {
    func observe(completion: @escaping ([Payload]?, Error?) -> Void)

    @available(iOS 15, *)
    func observe() async throws -> [Payload]
}


