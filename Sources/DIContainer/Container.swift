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
        let keyName = KeyName(type).name
        return modules[keyName]
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

    /// Assigns the current container to the composition root.
    func build() {
        // Used later in property wrapper
        Self.root = self
    }
}

// MARK: Module List Helper
public extension [Module] {
    /// Replaces the first occurrence of a module with the same name as the given `newModule` in the array.
    ///
    /// If no module with the same name is found, the `newModule` is appended to the end of the array.
    ///
    /// - Parameter newModule: The new module to replace the existing one.
    mutating func replace(_ newModule: Module) {
        removeAll(where: { $0.name == newModule.name })
        append(newModule)
    }

    /// Replaces all modules in the array with the same names as the modules in the given `newModules` array.
    ///
    /// Modules in the current array that have names matching any of the modules in the `newModules` array will be removed, and the new modules will be appended to the end of the array.
    ///
    /// - Parameter newModules: The new modules to replace the existing ones.
    mutating func replace(contentsOf newModules: [Module]) {
        let keyNames = newModules.map(\.name)
        removeAll(where: {
            let keyName = $0.name
            if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
                return keyNames.contains([keyName])
            } else {
                return keyNames.contains(where: { $0 == keyName })
            }
        })
        append(contentsOf: newModules)
    }

    /// Returns a new array with the first occurrence of the given `newModule` replaced.
    ///
    /// The original array is not modified.
    ///
    /// - Parameter newModule: The new module to replace the existing one.
    /// - Returns: A new array with the replacement made.
    func replacing(_ newModule: Module) -> Self {
        var list = self
        list.replace(newModule)
        return list
    }

    /// Returns a new array with all modules replaced with the modules in the given `newModules` array.
    ///
    /// The original array is not modified.
    ///
    /// - Parameter newModules: The new modules to replace the existing ones.
    /// - Returns: A new array with the replacements made.
    func replacing(contentsOf newModules: [Module]) -> Self {
        var list = self
        list.replace(contentsOf: newModules)
        return list
    }
}
