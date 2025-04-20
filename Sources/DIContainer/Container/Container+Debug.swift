#if DEBUG
import Foundation

@MainActor
public extension Container {
    static func clear() {
        root = .init()
    }

    static func register(_ module: Module) {
        root.register(module: module)
    }

    static func register(contentsOf newElements: [Module]) {
        root.register(contentsOf: newElements)
    }
}
#endif
