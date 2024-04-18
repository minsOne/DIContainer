import Foundation

/// A type that contributes to the object graph.
public struct Module: Hashable {
    let name: String
    let resolve: () -> Any

    public init<T: InjectionKeyType, U>(
        _ keyType: T.Type,
        _ resolve: @escaping () -> U
    ) where T.Value == U {
        name = KeyName(keyType).name
        self.resolve = resolve
    }

    public init<T: AutoModule>(_ moduleType: T.Type) {
        name = KeyName(moduleType.ModuleKeyType.self).name
        resolve = {
            moduleType.init()
        }
    }

    public static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
