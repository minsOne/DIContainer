#if DEBUG
import Foundation

public protocol AutoRegisterModuleProtocol {
    associatedtype ModuleKey: InjectionKey
    var key: ModuleKey? { get }
    init()
}

public extension AutoRegisterModuleProtocol {
    static var module: Module {
        Module(ModuleKey.self, { Self.init() as! Self.ModuleKey.Value })
    }
}
#endif
