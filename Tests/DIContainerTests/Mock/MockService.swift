import DIContainer
import Foundation

class MockServiceKey: InjectionKeyType
{
    var injectKey: MockService?
}

protocol MockService {
    func doSomething()
}

class MockServiceImpl: InjectionModule, MockService
{
    var injectKey: MockServiceKey?
    var count = 0
    
    func doSomething() {
        count += 1
        print("\(Self.self) doing something... count : \(count)")
    }
}
