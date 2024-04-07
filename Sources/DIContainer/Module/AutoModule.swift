import Foundation

open class AutoModuleBase {
    public required init() {}
}

public protocol AutoModulable: AnyObject {
    associatedtype ModuleKeyType: InjectionKeyType
}

public typealias AutoModule = AutoModuleBase & AutoModulable

#if DEBUG
public extension AutoModulable {
    var module: Module? {
        (self as? ModuleKeyType.Value)
            .map { instance in Module(ModuleKeyType.self) { instance } }
    }
}
#endif
