import XCTest
@testable import DIContainer

final class DIContainerTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        let container = Container {
            Component(ServiceKey.self) { ServiceImpl() }
//            Component(ServiceKey.self) { Int(10) }
        }
        container.build()
    }
    
    func testRegistedService() {
        @Inject(ServiceKey.self)
        var service: Service
        
        service.doSomething()
        _ = ServiceKey.currentValue
    }
}
