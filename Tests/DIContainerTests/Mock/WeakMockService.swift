import DIContainer
import Foundation

class WeakMockServiceKey: InjectionKey
{
    var injectKey: WeakMockService?
}

protocol WeakMockService {
    func doSomething()
}

class WeakMockServiceImpl: WeakMockService,
                           InjectionModulable
{
    var injectKey: WeakMockServiceKey?

    var count = 0
    
    required init() {}

    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
