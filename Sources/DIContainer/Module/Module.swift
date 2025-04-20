import Foundation

/// A type that contributes to the object graph.
@preconcurrency
public struct Module: Hashable {
    let name: String
    let resolve: () -> Any

    @MainActor
    public init<T: InjectionKeyType, U>(
        _ keyType: T.Type,
        _ resolve: @escaping () -> U
    ) where T.Value == U {
        let name = KeyName(keyType).name
        self.init(name: name, resolve: resolve)
    }

    @MainActor
    public init<T: AutoModule>(_ moduleType: T.Type) {
        let name = KeyName(moduleType.ModuleKeyType.self).name
        self.init(name: name, resolve: {
            moduleType.init()
        })
    }

    @MainActor
    init(name: String, resolve: @escaping () -> Any) {
        self.name = name
        self.resolve = resolve
    }
}

public extension Module {
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
