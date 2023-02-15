import DIContainer
import Foundation

class WeakMockServiceKey: ScanInjectionKey,
                          InjectionKey
{
    var type: WeakMockService?
}

protocol WeakMockService {
    func doSomething()
}

class WeakMockServiceImpl: InjectModule,
                           InjectModuleProtocol,
                           WeakMockService
{
    typealias ModuleKey = WeakMockServiceKey
    var key: ModuleKey?

    var count = 0

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
