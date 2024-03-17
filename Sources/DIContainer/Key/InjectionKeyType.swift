import Foundation

public protocol InjectionKeyType: AnyObject {
    associatedtype Value
    static var value: Value { get }
    static var weakValue: Value? { get }
}

public extension InjectionKeyType {
    static var value: Value {
        Container.resolve(for: Self.self)
    }
    
    static var weakValue: Value? {
        Container.weakResolve(for: Self.self)
    }
}

/// DO NOT USE THIS CODE DIRECTLY
open class InjectionKeyScanType {}

public typealias InjectionKey = InjectionKeyScanType & InjectionKeyType
