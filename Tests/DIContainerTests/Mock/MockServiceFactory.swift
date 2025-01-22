import DIContainer
import Foundation

final class MockServiceFactoryKey: InjectionKey {
    typealias Value = MockServiceFactoryProtocol
}

protocol MockServiceFactoryProtocol {
    func makeWeakService() -> WeakMockService
    func makeService() -> MockService
}

final class MockServiceFactory: AutoModule, MockServiceFactoryProtocol {
    typealias ModuleKeyType = MockServiceFactoryKey

    func makeWeakService() -> WeakMockService {
        WeakMockServiceImpl()
    }
    
    func makeService() -> MockService {
        MockServiceImpl()
    }
}
