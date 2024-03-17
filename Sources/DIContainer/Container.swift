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
    @discardableResult
    func add(module: Module) -> Self {
        let key = module.name
        if let _ = modules[key] {
            assertionFailure("\(key) Key is existed. Please check module \(module)")
        }
        modules[key] = module
        return self
    }

    @discardableResult
    func append(contentsOf newElements: [Module]) -> Self {
        newElements.forEach { add(module: $0) }
        return self
    }
}

extension Container {
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    static func resolve<T>(for type: AnyObject.Type) -> T {
        guard let component: T = weakResolve(for: type) else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }

        return component
    }

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, return nil
    static func weakResolve<T>(for type: AnyObject.Type) -> T? {
        root.module(type)?.resolve() as? T
    }

    func module(_ type: AnyObject.Type) -> Module? {
        let key = Utils().keyName(type)
        return modules[key]
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
        append(contentsOf: modules())
    }

    /// Construct dependency resolutions.
    convenience init(modules: [Module]) {
        self.init()
        append(contentsOf: modules)
    }

    /// Construct dependency resolution.
    convenience init(@ContainerBuilder _ module: () -> Module) {
        self.init()
        append(contentsOf: [module()])
    }

    /// Assigns the current container to the composition root.
    func build() {
        // Used later in property wrapper
        Self.root = self
    }
}
