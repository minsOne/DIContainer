import DIContainer
import Foundation

class MockServiceKey: ScanInjectionKey,
                      InjectionKey
{
    var type: MockService?
}

protocol MockService {
    func doSomething()
}

class MockServiceImpl: InjectModule,
                       InjectModuleProtocol,
                       MockService
{
    typealias ModuleKey = MockServiceKey
    var key: ModuleKey?
    var count = 0

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
