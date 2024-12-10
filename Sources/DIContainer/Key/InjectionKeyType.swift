import Foundation

@MainActor
public protocol InjectionKeyType: AnyObject {
    associatedtype Value
    static var value: Value { get }
    static var weakValue: Value? { get }
}

@MainActor
public extension InjectionKeyType {
    static var value: Value {
        Container.resolve(for: Self.self)
    }

    static var weakValue: Value? {
        Container.weakResolve(for: Self.self)
    }
}

/// DO NOT USE THIS CODE DIRECTLY
open class InjectionBaseKeyType {}

public typealias InjectionKey = InjectionBaseKeyType & InjectionKeyType
