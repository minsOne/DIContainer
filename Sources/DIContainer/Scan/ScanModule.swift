import Foundation

open class ScanModule {
    public required init() {}
}

public protocol ScanModuleProtocol {
    associatedtype ModuleKey: InjectionKey
    var key: ModuleKey? { get }
    static var module: Module { get }
}

public extension ScanModuleProtocol where Self: ScanModule {
    static var module: Module {
        return Module(ModuleKey.self) { self.init() as! Self.ModuleKey.Value }
    }
}
