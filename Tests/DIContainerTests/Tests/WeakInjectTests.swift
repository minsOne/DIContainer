import XCTest
@testable import DIContainer

final class WeakInjectTests: XCTestCase {
    let mock: WeakMockServiceImpl = .init()

    override func setUp() {
        super.setUp()

        let mock = self.mock

        Container {
            Module(WeakMockServiceKey.self) { mock }
            Module(MockServiceKey.self) { MockServiceImpl() }
        }
        .build()
    }

    func test_컨테이너_등록여부_확인_1() {
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve())
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value)
        XCTAssertNotNil(WeakMockServiceKey.module?.resolve() as? WeakMockService)
    }

    func test_컨테이너_등록여부_확인_2() {
        @WeakInject(WeakMockServiceKey.self) var service;
        XCTAssertNotNil(service)
    }
    
    func test_WeakInject_동작확인_1() {
        @WeakInject(WeakMockServiceKey.self)
        var service: WeakMockService?
        XCTAssertNotNil(service)

        service?.doSomething()
        XCTAssertEqual(mock.count, 1)
    }

    func test_WeakInject_동작확인_2() {
        @WeakInject(WeakMockServiceKey.self) var service;
        XCTAssertNotNil(service)

        service?.doSomething()
        XCTAssertEqual(mock.count, 1)
    }
}
