import Foundation
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
        try await withCheckedThrowingContinuation { continuation in
            observe { payloads, error in
                if let payloads = payloads {
                    continuation.resume(returning: payloads)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
        }
    }
}
