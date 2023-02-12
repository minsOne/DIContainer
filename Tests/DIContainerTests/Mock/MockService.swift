import DIContainer
import Foundation

class MockServiceKey: InjectionKey {
    var type: MockService?
}

protocol MockService {
    func doSomething()
}

class MockServiceImpl: MockService, AutoRegisterModuleProtocol {
    typealias ModuleKey = MockServiceKey
    var key: ModuleKey?
    var count = 0

    required init() {}

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
