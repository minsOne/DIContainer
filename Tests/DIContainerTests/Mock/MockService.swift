import DIContainer
import Foundation

class MockServiceKey: InjectionKey {
    var type: MockService?
}

protocol MockService {
    func doSomething()
}

class MockServiceImpl: MockService {
    var count = 0

    func doSomething() {
        print("Doing something...")
        count += 1
    }
}
