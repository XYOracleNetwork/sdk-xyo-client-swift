open class AbstractWitness: AbstractModule, Witness {
    open func observe() -> [XyoPayload] {
        preconditionFailure("This method must be overridden")
    }
}

open class AbstractAsyncWitness: AbstractModule, WitnessAsync {
    open func observe(completion: @escaping ([XyoPayload]?, Error?) -> Void) {
        preconditionFailure("This method must be overridden")
    }
    @available(iOS 15, *)
    open func observe() async throws -> [XyoPayload] {
        preconditionFailure("This method must be overridden")
    }
}
