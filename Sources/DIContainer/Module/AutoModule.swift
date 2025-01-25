import Foundation

open class AutoModuleBase {
    public required init() {}

    fileprivate func __newInstance() -> Self {
        Self()
    }
}

public protocol AutoModulable: AnyObject {
    associatedtype ModuleKeyType: InjectionKeyType
}

public typealias AutoModule = AutoModuleBase & AutoModulable

#if DEBUG
extension AutoModulable {
    var module: Module? {
        guard
            let instance = self as? ModuleKeyType.Value,
            let autoModuleBase = instance as? AutoModuleBase
        else { return nil }

        return Module(ModuleKeyType.self) {
            (autoModuleBase.__newInstance() as? ModuleKeyType.Value)
                ?? instance
        }
    }
}
#endif
