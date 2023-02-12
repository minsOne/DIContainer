import DIContainer
import Foundation

class WeakMockServiceKey: InjectionKey {
    var type: WeakMockService?
}

protocol WeakMockService {
    func doSomething()
}

class WeakMockServiceImpl: WeakMockService, AutoRegisterModuleProtocol {
    typealias ModuleKey = WeakMockServiceKey
    var key: ModuleKey?

    var count = 0

    required init() {}

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
