import CoreData
import Foundation

/// `NSManagedObject` subclass for the `HashStore` Core Data entity.
///
/// This is provided manually (the model entity uses no code generation) so the package builds
/// under plain SwiftPM (`swift build`/`swift test`), which compiles the `.xcdatamodeld` with
/// `momc` but does not generate `NSManagedObject` subclasses the way Xcode's build system does.
@objc(HashStore)
public class HashStore: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HashStore> {
        return NSFetchRequest<HashStore>(entityName: "HashStore")
    }

    @NSManaged public var address: String?
    @NSManaged public var previousHash: String?
}
