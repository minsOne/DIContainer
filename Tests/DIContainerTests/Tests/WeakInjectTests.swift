import Testing

@testable import DIContainer

struct WeakInjectTests {
    init() {
        // Given
        Container {
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
            Module(MockServiceImpl.self)
        }
        .build()
    }

    @Test
    func testContainerRegistration1() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        #expect(weakMockService.isNotNil)
        #expect(weakMockServiceImpl.isNotNil)
        #expect(weakMockServiceProtocol.isNotNil)
    }

    @Test
    func testContainerRegistration2() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2

        // Then
        #expect(service1.isNotNil)
        #expect(service2.isNotNil)
    }

    @Test
    func testWeakInjectBehavior1() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1: WeakMockService?
        @WeakInject(MockServiceKey.self) var service2: MockService?

        // Then
        #expect(service1.isNotNil)
        service1?.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 1)

        #expect(service2.isNotNil)
        service2?.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 1)
    }

    @Test
    func testWeakInjectBehavior2() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2

        // Then
        #expect(service1.isNotNil)
        service1?.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 1)

        #expect(service2.isNotNil)
        service2?.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 1)
    }
}
