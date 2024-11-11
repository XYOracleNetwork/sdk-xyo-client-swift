open class XyoWitness: XyoModule, Witness {
  open func observe() -> [XyoPayload] {
    preconditionFailure("This method must be overridden")
  }
}
