import Foundation

public protocol WitnessModule: Module {}

open class WitnessModuleSync: AbstractModule, WitnessSync, WitnessModule {
    open func observe() -> [Payload] {
        preconditionFailure("This method must be overridden")
    }
}

open class WitnessModuleAsync: AbstractModule, WitnessAsync, WitnessModule {
    open func observe(completion: @escaping ([Payload]?, Error?) -> Void) {
        preconditionFailure("This method must be overridden")
    }

    @available(iOS 15, *)
    open func observe() async throws -> [Payload] {
        try await withCheckedThrowingContinuation { continuation in
            observe { payloads, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let payloads = payloads {
                    continuation.resume(returning: payloads)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
}
