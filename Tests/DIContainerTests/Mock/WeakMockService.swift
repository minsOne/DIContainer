import DIContainer
import Foundation

class WeakMockServiceKey: InjectionKey {
    typealias Value = WeakMockService
}

protocol WeakMockService {
    func doSomething()
}

class WeakMockServiceImpl: InjectionModule, WeakMockService {
    typealias ModuleKeyType = WeakMockServiceKey

    var count = 0
    
    required init() {}

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
