import CoreData

public class CoreDataPreviousHashStore: PreviousHashStore {
    private let context: NSManagedObjectContext

    public init(provider: PersistentContainerProvider = DefaultPersistentContainerProvider()) {
        self.context = provider.persistentContainer.viewContext
    }

    public func getItem(address: Address) -> Hash? {
        let fetchRequest: NSFetchRequest<HashStore> = HashStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address.toHex())
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            guard let previousHash = results.first?.previousHash else { return nil }
            return Hash(previousHash)
        } catch {
            print("Failed to fetch item for address \(address): \(error)")
            return nil
        }
    }

    public func removeItem(address: Address) {
        let fetchRequest: NSFetchRequest<HashStore> = HashStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address.toHex())

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Failed to remove item for address \(address): \(error)")
        }
    }

    public func setItem(address: Address, previousHash: Hash) {
        let fetchRequest: NSFetchRequest<HashStore> = HashStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address.toHex())
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)

            if let existingEntry = results.first {
                existingEntry.previousHash = previousHash.toHex()
            } else {
                let newEntry = HashStore(context: context)
                newEntry.address = address.toHex()
                newEntry.previousHash = previousHash.toHex()
            }

            try context.save()
        } catch {
            print("Failed to set item for address \(address): \(error)")
        }
    }
}
