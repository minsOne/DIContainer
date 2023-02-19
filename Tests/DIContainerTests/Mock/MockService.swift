import DIContainer
import Foundation

class MockServiceKey: InjectionKey
{
    var injectKey: MockService?
}

protocol MockService {
    func doSomething()
}

class MockServiceImpl: InjectionModulable,
                       MockService
{
    var injectKey: MockServiceKey?
    var count = 0

    required init() {}
    
    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
