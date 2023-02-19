import Foundation

public protocol InjectionModulable: AnyObject {
    associatedtype ModuleKeyType: InjectionKey
    var injectKey: ModuleKeyType? { get }
    init()
}

public extension InjectionModulable {
    static var module: Module? {
        guard
            let instance = Self.init() as? Self.ModuleKeyType.Value
        else { return nil }

        return Module(ModuleKeyType.self) { instance }
    }
}
