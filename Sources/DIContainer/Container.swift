import Foundation

public class Container {
    /// Stored object instance factories.
    var modules: [String: Module] = [:]
    
    public init() {}
    deinit { modules.removeAll() }
    
    /// Registers a specific type and its instantiating factory.
    func add(module: Module) {
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
    public convenience init(@ContainerBuilder _ modules: () -> [Module]) {
        self.init()
        modules().forEach { add(module: $0) }
    }

    /// Construct dependency resolution.
    public convenience init(@ContainerBuilder _ module: () -> Module) {
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
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
        public static func buildEither(first module: Module) -> Module { module }
    }
}
