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
    func containerRegistration2() {
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
    func weakInjectBehavior1() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1: WeakMockService?
        @WeakInject(MockServiceKey.self) var service2: MockService?
        
        // Then
        #expect(service1 != nil)
        service1?.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 1)
        
        #expect(service2 != nil)
        service2?.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 1)
    }
    
    @Test
    func weakInjectBehavior2() {
        // When
        @WeakInject(WeakMockServiceKey.self) var service1
        @WeakInject(MockServiceKey.self) var service2
        
        // Then
        #expect(service1 != nil)
        service1?.doSomething()
        #expect((service1 as? WeakMockServiceImpl)?.count == 1)
        
        #expect(service2 != nil)
        service2?.doSomething()
        #expect((service2 as? MockServiceImpl)?.count == 1)
    }
    
    @Test
    func factoryBehavior() {
        @WeakInject(MockServiceFactoryKey.self) var factory
        let service = factory?.makeWeakService()

        #expect(service != nil)
        service?.doSomething()

        #expect((service as? WeakMockServiceImpl)?.count == 1)
    }
}
