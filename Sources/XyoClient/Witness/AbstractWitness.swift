open class AbstractWitness: AbstractModule, Witness {
  open func observe() -> [XyoPayload] {
    preconditionFailure("This method must be overridden")
  }
}
