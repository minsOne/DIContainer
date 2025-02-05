import Testing
import XCTest

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct WeakInjectNilTest {
    @Test
    func containerDoesNotContainWeakMockService() {
        Container.clear()

        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        #expect(weakMockService == nil)
        #expect(weakMockServiceImpl == nil)
        #expect(weakMockServiceProtocol == nil)
    }

    @Test
    func weakInjectReturnsNil() {
        Container.clear()

        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(WeakMockServiceKey.self) var service2: WeakMockService?

        // Then
        #expect(service1 == nil)
        #expect(service2 == nil)
    }
}
