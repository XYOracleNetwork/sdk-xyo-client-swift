import CoreData

public class TestPersistentContainerProvider: PersistentContainerProvider {
    public let persistentContainer: NSPersistentContainer

    init() {
        let model = loadHashStoreModel()

        persistentContainer = NSPersistentContainer(name: "TestModel", managedObjectModel: model)

        // Use an in-memory store for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error setting up in-memory store: \(error)")
            }
        }
    }
}
