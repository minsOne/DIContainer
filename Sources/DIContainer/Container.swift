import Foundation

public class Container {
    static var root = Container()

    /// Stored object instance factories.
    var modules: [String: Module] = [:]

    public init() {}
    deinit { modules.removeAll() }
}

public extension Container {
    /// Registers a specific type and its instantiating factory.
    func add(module: Module) -> Self {
        append(contentsOf: [module])
    }

    func append(contentsOf newElements: [Module]) -> Self {
        newElements.forEach { module in
            let key = module.name
            if let _ = modules[key] {
                assertionFailure("\(key) Key is existed. Please check module \(module)")
            }
            modules[key] = module
        }
        return self
    }
}

extension Container {
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    static func resolve<T>(for type: Any.Type?) -> T {
        guard let component: T = weakResolve(for: type) else {
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
}

public extension Container {
    /// DSL for declaring modules within the container dependency initializer.
    @resultBuilder enum ContainerBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }

    /// Construct dependency resolutions.
    convenience init(@ContainerBuilder _ modules: () -> [Module]) {
        self.init()
        _ = append(contentsOf: modules())
    }

    /// Construct dependency resolutions.
    convenience init(modules: [Module]) {
        self.init()
        _ = append(contentsOf: modules)
    }

    /// Construct dependency resolution.
    convenience init(@ContainerBuilder _ module: () -> Module) {
        self.init()
        _ = append(contentsOf: [module()])
    }

    /// Assigns the current container to the composition root.
    func build() {
        // Used later in property wrapper
        Self.root = self
    }
}
