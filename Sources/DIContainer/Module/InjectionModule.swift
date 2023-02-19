import Foundation

public protocol InjectionModulable: AnyObject {
    associatedtype ModuleKeyType: InjectionKey
    var injectKey: ModuleKeyType? { get }
    init()
}

public extension InjectionModulable {
    var module: Module? {
        guard
            let instance = self as? ModuleKeyType.Value
        else { return nil }

        return Module(ModuleKeyType.self) { instance }
    }
}
