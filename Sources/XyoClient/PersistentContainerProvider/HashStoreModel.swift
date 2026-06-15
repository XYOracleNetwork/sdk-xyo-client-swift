import CoreData
import Foundation

/// Resolves the Core Data `NSManagedObjectModel` for the previous-hash store.
///
/// When built with Xcode (or any build that compiles `Model.xcdatamodeld` to `Model.momd`),
/// the compiled model is loaded from the resource bundle. Under plain SwiftPM
/// (`swift build`/`swift test`) the model is not compiled, so an equivalent model is built
/// programmatically. Both paths yield the same `HashStore` entity, so behavior is identical.
func loadHashStoreModel() -> NSManagedObjectModel {
    if let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
        let model = NSManagedObjectModel(contentsOf: modelURL) {
        return model
    }
    return makeHashStoreModel()
}

private func makeHashStoreModel() -> NSManagedObjectModel {
    let model = NSManagedObjectModel()

    let entity = NSEntityDescription()
    entity.name = "HashStore"
    entity.managedObjectClassName = NSStringFromClass(HashStore.self)

    let address = NSAttributeDescription()
    address.name = "address"
    address.attributeType = .stringAttributeType
    address.isOptional = false

    let previousHash = NSAttributeDescription()
    previousHash.name = "previousHash"
    previousHash.attributeType = .stringAttributeType
    previousHash.isOptional = true

    entity.properties = [address, previousHash]
    model.entities = [entity]
    return model
}
