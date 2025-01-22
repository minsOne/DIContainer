import Testing
import XCTest

@testable import DIContainer

@MainActor
class ContainerTests: XCTestCase {
    func test_container1() {
        testContainer(withSetup: .init {
            Module(MockServiceKey.self) { MockServiceImpl() }
        })
    }

    func test_container2() {
        testContainer(withSetup: .init {
            Module(MockServiceImpl.self)
        })
    }
}

extension ContainerTests {
    private func testContainer(withSetup container: Container) {
        container.build()

        injection()
        injectBehavior()
    }

    private func injection() {
        let serviceKey = MockServiceKey.self
        #expect(serviceKey.module?.resolve() != nil)
        #expect(serviceKey.module?.resolve() as? MockServiceKey.Value != nil)
        #expect(serviceKey.module?.resolve() as? MockService != nil)

        @Inject(MockServiceKey.self) var service; _ = service
    }

    private func injectBehavior() {
        @Inject(MockServiceKey.self) var service: MockService
        service.doSomething()
        #expect((service as? MockServiceImpl)?.count == 1)
    }
}
