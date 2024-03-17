import Foundation

/// A type that contributes to the object graph.
public struct Module {
    let name: String
    let resolve: () -> Any

    public init<T: InjectionKeyType, U>(
        _ keyType: T.Type,
        _ resolve: @escaping () -> U
    ) where T.Value == U {
        self.name = Utils().keyName(keyType)
        self.resolve = resolve
    }

    public init<T: AutoModule>(_ moduleType: T.Type) {
        name = Utils().keyName(moduleType.ModuleKeyType.self)
        resolve = {
            moduleType.init()
        }
    }
}
