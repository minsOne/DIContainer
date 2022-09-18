import DIContainer
import Foundation

struct ServiceKey: InjectionKey {
    var type: Service?
}

protocol Service {
    func doSomething()
}

struct ServiceImpl: Service {
    func doSomething() {
        print("Doing something...")
    }
}
