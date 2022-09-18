import Foundation

/// A type that contributes to the object graph.
public struct Component {
    let name: String
    let resolve: () -> Any

    public init<T: InjectionKey, U>(
        _ name: T.Type,
        _ resolve: @escaping () -> U
    ) where T.Value == U {
        self.name = String(describing: name)
        self.resolve = resolve
    }
}
