import DIContainer
import Foundation

final class MockServiceKey: InjectionKey {
    typealias Value = MockService
}

protocol MockService {
    func doSomething()
}

final class MockServiceImpl: AutoModule, MockService {
    typealias ModuleKeyType = MockServiceKey

    var count = 0

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
