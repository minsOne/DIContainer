import Foundation

public class Container {
    @MainActor
    private(set) static var root = Container()

    /// Stored object instance factories.
    var modules: [String: Module] = [:]

    public init() {}
    deinit { modules.removeAll() }
}

public extension Container {
    /// Registers a specific type and its instantiating factory.
    @discardableResult
    func register(module: Module) -> Self {
        let key = module.name
        if let _ = modules[key] {
            assertionFailure("\(key) Key is existed. Please check module \(module)")
        }
        modules[key] = module
        return self
    }

    @discardableResult
    func register(contentsOf newElements: [Module]) -> Self {
        newElements.forEach { register(module: $0) }
        return self
    }
}

@MainActor
extension Container {
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    static func resolve<T, U: InjectionKeyType>(for type: U.Type) -> T {
        guard let component: T = weakResolve(for: type) else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }

        return component
    }

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, return nil
    static func weakResolve<T, U: InjectionKeyType>(for type: U.Type) -> T? {
        root.module(type)?.resolve() as? T
    }
    
    /// Check if the dependency is registered in the container.
    static func isRegistered<T: InjectionKeyType>(_ type: T.Type) -> Bool {
        root.module(type) != nil
    }

    func module<T: InjectionKeyType>(_ type: T.Type) -> Module? {
        let keyName = KeyName(type).name
        return modules[keyName]
    }
}

public extension Container {
    /// DSL for declaring modules within the container dependency initializer.
    @resultBuilder
    enum ContainerBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }

    /// Construct dependency resolutions.
    convenience init(@ContainerBuilder _ modules: () -> [Module]) {
        self.init()
        register(contentsOf: modules())
    }

    /// Construct dependency resolutions.
    convenience init(modules: [Module]) {
        self.init()
        register(contentsOf: modules)
    }

    /// Construct dependency resolution.
    convenience init(@ContainerBuilder _ module: () -> Module) {
        self.init()
        register(contentsOf: [module()])
    }
}

@MainActor
public extension Container {
    /// Assigns the current container to the composition root.
    func build() {
        // Used later in property wrapper
        Self.root = self
    }
}

#if DEBUG
@MainActor
public extension Container {
    static func clear() {
        root = .init()
    }
}

#endif
