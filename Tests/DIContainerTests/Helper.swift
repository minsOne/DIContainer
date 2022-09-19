@testable import DIContainer
import Foundation

extension InjectionKey {
    static var module: Component? {
        Container.root.modules[String(describing: Self.self)]
    }
}

