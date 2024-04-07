import XCTest

@testable import DIContainer

final class WeakInjectTests: XCTestCase {
    override func setUp() {
        super.setUp()

        // Given
        Container {
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
            Module(MockServiceImpl.self)
        }
        .build()
    }

    func testContainerRegistration1() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService

        // Then
        XCTAssertNotNil(weakMockService)
        XCTAssertNotNil(weakMockServiceImpl)
        XCTAssertNotNil(weakMockServiceProtocol)
    }

    func testContainerRegistration2() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2

        // Then
        XCTAssertNotNil(service1)
        XCTAssertNotNil(service2)
    }

    func testWeakInjectBehavior1() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1: WeakMockService?
        @WeakInject(MockServiceKey.self) var service2: MockService?

        // Then
        XCTAssertNotNil(service1)
        service1?.doSomething()
        XCTAssertEqual((service1 as? WeakMockServiceImpl)?.count, 1)

        XCTAssertNotNil(service2)
        service2?.doSomething()
        XCTAssertEqual((service2 as? MockServiceImpl)?.count, 1)
    }

    func testWeakInjectBehavior2() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2

        // Then
        XCTAssertNotNil(service1)
        service1?.doSomething()
        XCTAssertEqual((service1 as? WeakMockServiceImpl)?.count, 1)

        XCTAssertNotNil(service2)
        service2?.doSomething()
        XCTAssertEqual((service2 as? MockServiceImpl)?.count, 1)
    }
}
