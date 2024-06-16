import Testing

@testable import DIContainer

struct WeakInjectNilTests {
    let mockService = WeakMockServiceImpl()

    init() {
        // Given
        Container().build()
    }

    @Test
    func testContainerDoesNotContainWeakMockService() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        #expect(weakMockService.isNil)
        #expect(weakMockServiceImpl.isNil)
        #expect(weakMockServiceProtocol.isNil)
    }

    @Test
    func testWeakInjectReturnsNil() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(WeakMockServiceKey.self) var service2: WeakMockService?

        // Then
        #expect(service1.isNil)
        #expect(service2.isNil)
    }
}
