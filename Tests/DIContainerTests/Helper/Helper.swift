import Foundation

@testable import DIContainer

extension InjectionKeyType {
    @MainActor
    static var module: Module? {
        Container.root.module(Self.self)
    }
}
