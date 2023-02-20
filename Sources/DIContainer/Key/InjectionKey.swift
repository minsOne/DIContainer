import Foundation

/// 직접 사용하지 말것
open class InjectionKeyScanType {
    public init() {}
}

public protocol InjectionKey: AnyObject {
    associatedtype Value
    var injectKey: Value? { get }
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

public typealias InjectionKeyType = InjectionKeyScanType & InjectionKey
