import XCTest
@testable import DIContainer

final class DIContainerTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        let container = Container {
            Component(ServiceKey.self) { ServiceImpl() }
        }
        container.build()
    }
    
    func testRegistedService() {
        @Inject(ServiceKey.self)
        var service: Service
        
        service.doSomething()
    }
}
