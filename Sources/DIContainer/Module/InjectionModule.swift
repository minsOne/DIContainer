import Foundation

open class InjectionModuleScanType {
    required public init() {}
}

public protocol InjectionModulable: AnyObject {
    associatedtype ModuleKeyType: InjectionKey
    var injectKey: ModuleKeyType? { get }
}

public extension InjectionModulable {
    var module: Module? {
        guard
            let instance = self as? ModuleKeyType.Value
        else { return nil }

        return Module(ModuleKeyType.self) { instance }
    }
}

public typealias InjectionModule = InjectionModuleScanType & InjectionModulable
