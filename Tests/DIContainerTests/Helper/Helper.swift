import Foundation

@testable import DIContainer

extension InjectionKeyType {
    @MainActor
    static var module: Module? {
        return Container.root.module(Self.self)
    }
}
