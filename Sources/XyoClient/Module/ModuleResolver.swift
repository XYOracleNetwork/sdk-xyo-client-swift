import Foundation

/// Resolves modules by address, name, or supported query, matching the Android `ModuleResolver`.
/// For a client SDK this is typically a small, locally-populated resolver rather than full graph
/// resolution.
public protocol ModuleResolver {
    @available(iOS 15, *)
    func resolve(byAddress address: String) async throws -> ModuleInstance?
    @available(iOS 15, *)
    func resolve(byName name: String) async throws -> ModuleInstance?
    func resolve(byQuery query: String) -> [ModuleInstance]
    func resolveAll() -> [ModuleInstance]
}

/// A simple in-memory resolver over a fixed set of modules.
public final class StaticModuleResolver: ModuleResolver {
    private let modules: [ModuleInstance]

    public init(modules: [ModuleInstance]) {
        self.modules = modules
    }

    @available(iOS 15, *)
    public func resolve(byAddress address: String) async throws -> ModuleInstance? {
        modules.first { $0.address?.toHex() == address.lowercased() }
    }

    @available(iOS 15, *)
    public func resolve(byName name: String) async throws -> ModuleInstance? {
        modules.first { $0.modName == name }
    }

    public func resolve(byQuery query: String) -> [ModuleInstance] {
        modules.filter { $0.isSupportedQuery(query) }
    }

    public func resolveAll() -> [ModuleInstance] { modules }
}
