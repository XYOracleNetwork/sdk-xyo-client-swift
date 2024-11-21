import CoreData

public class DefaultPersistentContainerProvider: PersistentContainerProvider {
    public let persistentContainer: NSPersistentContainer

    public init() {
        // Locate the bundled Core Data model in the package's resources
        guard let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load Core Data model from the package.")
        }

        persistentContainer = NSPersistentContainer(name: "DefaultModel", managedObjectModel: model)

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data persistent stores: \(error)")
            }
        }
    }
}
