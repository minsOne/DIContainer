import Foundation

open class ScanModule {
    public required init() {}
}

public protocol ScanModuleProtocol: AnyObject {
    associatedtype ModuleKey: InjectionKey
    var key: ModuleKey? { get }
}

#if DEBUG
public extension ScanModuleProtocol where Self: ScanModule {
    var module: Module {
        return Module(ModuleKey.self) { self as! Self.ModuleKey.Value }
    }
}
#endif
