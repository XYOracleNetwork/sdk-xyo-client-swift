import CoreData

public protocol PersistentContainerProvider {
    var persistentContainer: NSPersistentContainer { get }
}
