import Foundation

// MARK: Module List Helper

public extension [Module] {
    /// Replaces the first occurrence of a module with the same name as the given `newModule` in the array.
    ///
    /// If no module with the same name is found, the `newModule` is appended to the end of the array.
    ///
    /// - Parameter newModule: The new module to replace the existing one.
    mutating func replace(_ newModule: Module) {
        if let index = firstIndex(where: { $0.name == newModule.name }) {
            self[index] = newModule
        } else {
            append(newModule)
        }
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
