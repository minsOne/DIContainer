import Testing
import XCTest

@testable import DIContainer

@MainActor
class ContainerTests: XCTestCase {
    func test_container1() throws {
        try testContainer(withSetup: .init {
            Module(MockServiceKey.self) { MockServiceImpl() }
        })
    }

    func test_container2() throws {
        try testContainer(withSetup: .init {
            Module(MockServiceImpl.self)
        })
    }
}

extension ContainerTests {
    private func testContainer(withSetup container: Container) throws {
        container.build()

        injection()
        try injectBehavior()
    }

    private func injection() {
        let serviceKey = MockServiceKey.self
        #expect(serviceKey.module?.resolve() != nil)
        #expect(serviceKey.module?.resolve() as? MockServiceKey.Value != nil)
        #expect(serviceKey.module?.resolve() as? MockService != nil)

        @Inject(MockServiceKey.self) var service; _ = service
    }

    private func injectBehavior() throws {
        @Inject(MockServiceKey.self) var service1: MockService
        service1.doSomething()
        service1.doSomething()
        #expect((service1 as? MockServiceImpl)?.count == 2)

        @Inject(MockServiceKey.self) var service2: MockService
        service2.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 1)
        
        let lhs = try #require(service1 as? MockServiceImpl)
        let rhs = try #require(service2 as? MockServiceImpl)
        
        #expect((lhs === rhs) == false)
    }
}
