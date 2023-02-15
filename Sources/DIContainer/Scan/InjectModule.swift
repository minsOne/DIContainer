import Foundation

open class InjectModule {
    public required init() {}
}

public protocol InjectModuleProtocol: AnyObject {
    associatedtype ModuleKey: InjectionKey
    var key: ModuleKey? { get }
}

#if DEBUG
public extension InjectModuleProtocol where Self: InjectModule {
    var module: Module {
        return Module(ModuleKey.self) { self as! Self.ModuleKey.Value }
    }
}
#endif
