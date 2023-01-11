import XCTest
@testable import DIContainer

final class DIContainerTests: XCTestCase {
    let mock: MockServiceImpl = .init()

    override func setUp() {
        super.setUp()

        let mock = self.mock

        Container {
            Module(MockServiceKey.self) { mock }
        }
        .build()
    }

    func test_컨테이너_등록여부_확인_1() {
        XCTAssertNotNil(MockServiceKey.module?.resolve() as? MockServiceKey.Value)
        XCTAssertNotNil(MockServiceKey.module?.resolve() as? MockService)
    }

    func test_컨테이너_등록여부_확인_2() {
        @Inject(MockServiceKey.self) var service; _ = service
    }
    
    func test_Inject동작확인_1() {
        @Inject(MockServiceKey.self)
        var service: MockService
        
        service.doSomething()
        XCTAssertEqual(mock.count, 1)
    }

    func test_Inject동작확인_2() {
        @Inject(MockServiceKey.self) var service;
        service.doSomething()
        XCTAssertEqual(mock.count, 1)
    }
}
