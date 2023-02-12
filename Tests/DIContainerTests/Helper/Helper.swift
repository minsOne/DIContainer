import Foundation

@testable import DIContainer

extension InjectionKey {
    static var module: Module? {
        Container.root.modules[String(describing: Self.self)]
    }
}
