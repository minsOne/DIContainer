import XCTest

@testable import DIContainer

final class WeakInjectNilTests: XCTestCase {
    let mock = WeakMockServiceImpl()

    override func setUp() {
        super.setUp()

        Container()
            .build()
    }

    func test_컨테이너_등록여부_확인_1() {
        XCTAssertNil(WeakMockServiceKey.module?.resolve())
        XCTAssertNil(WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value)
        XCTAssertNil(WeakMockServiceKey.module?.resolve() as? WeakMockService)
    }

    func test_컨테이너_등록여부_확인_2() {
        do {
            @WeakInject(WeakMockServiceKey.self) var service
            XCTAssertNil(service)
        }

        do {
            @WeakInject(WeakMockServiceKey.self)
            var service: WeakMockService?
            XCTAssertNil(service)
        }

        do {
            @WeakInject(WeakMockServiceKey.self) var service
            XCTAssertNil(service)
        }
    }
}
