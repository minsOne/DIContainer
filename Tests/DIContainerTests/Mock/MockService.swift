import DIContainer
import Foundation

@MainActor
final class MockServiceKey: InjectionKey {
    typealias Value = MockService
}

@MainActor
protocol MockService {
    func doSomething()
}

@MainActor
final class MockServiceImpl: AutoModule, MockService {
    typealias ModuleKeyType = MockServiceKey

    var count = 0

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
