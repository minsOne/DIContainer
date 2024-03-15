@testable import DIContainer
import XCTest

class ContainerTests: XCTestCase {
    private func testContainer(withSetup container: Container) {
        container.build()

        testInjection()
        testInjectBehavior()
    }

    private func testInjection() {
        let serviceKey = MockServiceKey.self
        XCTAssertNotNil(serviceKey.module?.resolve())
        XCTAssertNotNil(serviceKey.module?.resolve() as? MockServiceKey.Value)
        XCTAssertNotNil(serviceKey.module?.resolve() as? MockService)

        @Inject(MockServiceKey.self) var service; _ = service
    }

    private func testInjectBehavior() {
        @Inject(MockServiceKey.self) var service: MockService
        service.doSomething()
        XCTAssertEqual((service as? MockServiceImpl)?.count, 1)
        service.doSomething()
        XCTAssertEqual((service as? MockServiceImpl)?.count, 2)
    }

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
