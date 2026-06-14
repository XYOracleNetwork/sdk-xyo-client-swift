import CoreData

public class DefaultPersistentContainerProvider: PersistentContainerProvider {
    public let persistentContainer: NSPersistentContainer

    public init() {
        let model = loadHashStoreModel()

        persistentContainer = NSPersistentContainer(name: "DefaultModel", managedObjectModel: model)

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data persistent stores: \(error)")
            }
        }
    }
}
