import Foundation

public class Container {
    /// Stored object instance factories.
    var modules: [String: Module] = [:]

    public init() {}
    deinit { modules.removeAll() }

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

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, return nil
    static func weakResolve<T>(for type: Any.Type?) -> T? {
        let name = type.map { String(describing: $0) } ?? String(describing: T.self)

        return root.modules[name]?.resolve() as? T
    }

    static var root = Container()

    /// Registers a specific type and its instantiating factory.
    public func add(module: Module) -> Self {
        return append(contentsOf: [module])
    }

    public func append(contentsOf newElements: [Module]) -> Self {
        newElements.forEach { module in
            let key = module.name
            if let _ = modules[key] {
                assertionFailure("\(key) Key is existed. Please check module \(module)")
            }
            modules[key] = module
        }
        return self
    }

    /// Construct dependency resolutions.
    public convenience init(@ContainerBuilder _ modules: () -> [Module]) {
        self.init()
        _ = append(contentsOf: modules())
    }

    /// Construct dependency resolutions.
    public convenience init(modules: [Module]) {
        self.init()
        _ = append(contentsOf: modules)
    }

    /// Construct dependency resolution.
    public convenience init(@ContainerBuilder _ module: () -> Module) {
        self.init()
        _ = append(contentsOf: [module()])
    }

    /// Assigns the current container to the composition root.
    public func build() {
        // Used later in property wrapper
        Self.root = self
    }

    /// DSL for declaring modules within the container dependency initializer.
    @resultBuilder public enum ContainerBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }
}
