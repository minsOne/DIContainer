import Foundation

public protocol InjectionKey {
    associatedtype Value
    var type: Value? { get }
    static var currentValue: Value { get }
}

public extension InjectionKey {
    static var currentValue: Value {
        return Container.resolve(for: Self.self)
    }
}
