import XCTest

@testable import DIContainer

final class WeakInjectTests: XCTestCase {
    override func setUp() {
        super.setUp()

        Container {
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
            Module(MockServiceImpl.self)
        }
        .build()
    }

    func test_컨테이너_등록여부_확인_1() {
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve())
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value)
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve() as? WeakMockService)
    }

    func test_컨테이너_등록여부_확인_2() {
        @WeakInject(WeakMockServiceKey.self) var service1
        XCTAssertNotNil(service1)

        @WeakInject(MockServiceKey.self) var service2
        XCTAssertNotNil(service2)
    }

    func test_WeakInject_동작확인_1() {
        @WeakInject(WeakMockServiceKey.self) var service1: WeakMockService?
        XCTAssertNotNil(service1)
        service1?.doSomething()
        XCTAssertEqual((service1 as? WeakMockServiceImpl)?.count, 1)

        @WeakInject(MockServiceKey.self) var service2: MockService?
        XCTAssertNotNil(service2)
        service2?.doSomething()
        XCTAssertEqual((service2 as? MockServiceImpl)?.count, 1)
    }

    func test_WeakInject_동작확인_2() {
        @WeakInject(WeakMockServiceKey.self) var service1
        XCTAssertNotNil(service1)
        service1?.doSomething()
        XCTAssertEqual((service1 as? WeakMockServiceImpl)?.count, 1)

        @WeakInject(MockServiceKey.self) var service2
        XCTAssertNotNil(service2)
        service2?.doSomething()
        XCTAssertEqual((service2 as? MockServiceImpl)?.count, 1)
    }
}
