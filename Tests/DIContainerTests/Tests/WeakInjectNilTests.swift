import XCTest

@testable import DIContainer

final class WeakInjectNilTests: XCTestCase {
    let mockService = WeakMockServiceImpl()

    override func setUp() {
        super.setUp()

        // Given
        Container().build()
    }

    func testContainerDoesNotContainWeakMockService() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        XCTAssertNil(weakMockService)
        XCTAssertNil(weakMockServiceImpl)
        XCTAssertNil(weakMockServiceProtocol)
    }

    func testWeakInjectReturnsNil() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(WeakMockServiceKey.self) var service2: WeakMockService?

        // Then
        XCTAssertNil(service1)
        XCTAssertNil(service2)
    }
}
