import CoreData

public class TestPersistentContainerProvider: PersistentContainerProvider {
    public let persistentContainer: NSPersistentContainer

    init() {
        // Load the Core Data model
        guard let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load Core Data model.")
        }

        persistentContainer = NSPersistentContainer(name: "TestModel", managedObjectModel: model)

        // Use an in-memory store for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error setting up in-memory store: \(error)")
            }
        }
    }
}
