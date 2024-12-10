import Testing
import XCTest

@testable import DIContainer

@MainActor
struct WeakInjectNilTest {
    init() {
        Container().build()
    }
}

extension WeakInjectNilTest {
    @Test
    func containerDoesNotContainWeakMockService() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        XCTAssertNil(weakMockService)
        XCTAssertNil(weakMockServiceImpl)
        XCTAssertNil(weakMockServiceProtocol)
    }

    @Test
    func weakInjectReturnsNil() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(WeakMockServiceKey.self) var service2: WeakMockService?

        // Then
        XCTAssertNil(service1)
        XCTAssertNil(service2)
    }
}
