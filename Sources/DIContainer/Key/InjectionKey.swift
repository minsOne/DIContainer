import Foundation

public protocol InjectionKey: AnyObject {
    associatedtype Value
    var type: Value? { get }
    static var value: Value { get }
    static var weakValue: Value? { get }
}

public extension InjectionKey {
    static var value: Value {
        Container.resolve(for: Self.self)
    }

    static var weakValue: Value? {
        Container.weakResolve(for: Self.self)
    }
}
