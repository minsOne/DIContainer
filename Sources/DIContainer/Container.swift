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

public class Container {
    /// Stored object instance factories.
    var modules: [String: Component] = [:]
    
    public init() {}
    deinit { modules.removeAll() }
    
    /// Registers a specific type and its instantiating factory.
    func add(module: Component) {
        modules[module.name] = module
    }
    
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    static func resolve<T>(for type: Any.Type?) -> T {
        let name = type.map { String(describing: $0) } ?? String(describing: T.self)

        guard let component: T = root.modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }

        return component
    }
    
    static var root = Container()
    
    /// Construct dependency resolutions.
    public convenience init(@ContainerBuilder _ modules: () -> [Component]) {
        self.init()
        modules().forEach { add(module: $0) }
    }

    /// Construct dependency resolution.
    public convenience init(@ContainerBuilder _ module: () -> Component) {
        self.init()
        add(module: module())
    }

    /// Assigns the current container to the composition root.
    public func build() {
        // Used later in property wrapper
        Self.root = self
    }

    /// DSL for declaring modules within the container dependency initializer.
    @resultBuilder public struct ContainerBuilder {
        public static func buildBlock(_ modules: Component...) -> [Component] { modules }
        public static func buildBlock(_ module: Component) -> Component { module }
    }
}
