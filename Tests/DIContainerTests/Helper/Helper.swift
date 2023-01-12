@testable import DIContainer
import Foundation

extension InjectionKey {
    static var module: Module? {
        Container.root.modules[String(describing: Self.self)]
    }
}

