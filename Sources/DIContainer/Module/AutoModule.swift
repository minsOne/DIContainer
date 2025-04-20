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

public typealias AutoModule = AutoModulable & AutoModuleBase

#if DEBUG
@MainActor
extension AutoModulable where Self: AutoModuleBase {
    static var module: Module? {
        Self().module
    }
}

extension AutoModulable {
    @MainActor
    private var module: Module? {
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
