import Foundation

@testable import DIContainer

extension InjectionKeyType {
    static var module: Module? {
        return Container.root.module(Self.self)
    }
}

extension Optional {
    var isNil: Bool {
        self == nil
    }
    var isNotNil: Bool {
        !isNil
    }
}
