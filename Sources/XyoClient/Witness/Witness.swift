public protocol Witness {
    func observe() -> [XyoPayload]
}

public protocol WitnessAsync {
    func observe(completion: @escaping ([XyoPayload]?, Error?) -> Void)
}
