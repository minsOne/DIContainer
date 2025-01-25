import Testing
import XCTest

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct WeakInjectTest {
    init() {
        // Given
        Container {
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
            Module(MockServiceImpl.self)
            Module(MockServiceFactoryKey.self) { MockServiceFactory() }
        }
        .build()
    }
}

extension WeakInjectTest {
    @Test
    func containerRegistration1() {
        // When
        let weakMockService = WeakMockServiceKey.module?.resolve()
        let weakMockServiceImpl = WeakMockServiceKey.module?.resolve() as? WeakMockServiceKey.Value
        let weakMockServiceProtocol = WeakMockServiceKey.module?.resolve() as? WeakMockService
        
        // Then
        #expect(weakMockService != nil)
        #expect(weakMockServiceImpl != nil)
        #expect(weakMockServiceProtocol != nil)
    }
    
    @Test
    func containerRegistration2() throws {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2
        @WeakInject(MockServiceFactoryKey.self) var factory
        
        // Then
        #expect(service1 != nil)
        #expect(service2 != nil)
        #expect(factory != nil)
    }
    
    @Test
    func weakInjectBehavior1() throws {
        // When
        @WeakInject(WeakMockServiceKey.self) var _service1: WeakMockService?
        @WeakInject(MockServiceKey.self) var _service2: MockService?
        @WeakInject(WeakMockServiceKey.self) var _service3: WeakMockService?
        
        // Then
        let service1 = try #require(_service1)
        service1.doSomething()
        service1.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 2)
        
        let service2 = try #require(_service2)
        service2.doSomething()
        service2.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 2)
        
        let service3 = try #require(_service3)
        service3.doSomething()
        service3.doSomething()
        #expect((service3 as? WeakMockServiceImpl)?.count == 2)
        
        let lhs = try #require(service1 as? WeakMockServiceImpl)
        let rhs = try #require(service3 as? WeakMockServiceImpl)
        #expect((lhs === rhs) == false)
    }
    
    @Test
    func weakInjectBehavior2() throws {
        // When
        @WeakInject(WeakMockServiceKey.self) var _service1
        @WeakInject(MockServiceKey.self) var _service2
        @WeakInject(MockServiceKey.self) var _service3
        
        // Then
        let service1 = try #require(_service1)
        service1.doSomething()
        service1.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 2)
        
        let service2 = try #require(_service2)
        service2.doSomething()
        service2.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 2)
        
        let service3 = try #require(_service3)
        service3.doSomething()
        service3.doSomething()
        #expect((service3 as? MockServiceImpl)?.count == 2)
        
        let lhs = try #require(service2 as? MockServiceImpl)
        let rhs = try #require(service3 as? MockServiceImpl)
        #expect((lhs === rhs) == false)
    }
    
    @Test
    func factoryBehavior() throws {
        @WeakInject(MockServiceFactoryKey.self) var factory
        let _service1 = factory?.makeWeakService()
        let _service2 = factory?.makeWeakService()
        
        let service1 = try #require(_service1)
        service1.doSomething()
        service1.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 2)
        
        let service2 = try #require(_service2)
        service2.doSomething()
        service2.doSomething()
        #expect((service2 as? WeakMockServiceImpl)?.count == 2)
        
        let lhs = try #require(service1 as? WeakMockServiceImpl)
        let rhs = try #require(service2 as? WeakMockServiceImpl)
        #expect((lhs === rhs) == false)
    }
}
