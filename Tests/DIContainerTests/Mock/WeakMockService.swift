import DIContainer
import Foundation

struct WeakMockServiceKey: InjectionKey {
    var type: WeakMockService?
}

protocol WeakMockService {
    func doSomething()
}

class WeakMockServiceImpl: WeakMockService {
    var count = 0

    func doSomething() {
        print("Doing something...")
        count += 1
    }
}
