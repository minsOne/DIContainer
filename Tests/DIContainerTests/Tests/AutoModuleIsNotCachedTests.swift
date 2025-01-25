//
//  AutoModuleIsNotCachedTests.swift
//  DIContainer
//
//  Created by minsOne on 1/23/25.
//

import Testing

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct AutoModuleIsNotCachedTests {
    init() {
        Container.autoRegisterModules()
    }
}

extension AutoModuleIsNotCachedTests {
    @Test
    func scannedModule() throws {
        let _service1 = getMockService()
        let _service2 = getMockService()

        _service1.doSomething()
        let service1 = try #require(_service1 as? MockServiceImpl)
        #expect(service1.count == 1)

        _service2.doSomething()
        let service2 = try #require(_service2 as? MockServiceImpl)
        #expect(service2.count == 1)
        
        #expect((service1 === service2) == false)
    }

    @Test
    func generateService() throws {
        let factory1 = getMockServiceFactory()
        let factory2 = getMockServiceFactory()

        let service1 = factory1.makeService()
        service1.doSomething()

        do {
            let service = try #require(service1 as? MockServiceImpl)
            #expect(service.count == 1)
        }

        let service2 = factory2.makeService()
        service2.doSomething()

        do {
            let service = try #require(service2 as? MockServiceImpl)
            #expect(service.count == 1)
        }
    }
}

private extension AutoModuleIsNotCachedTests {
    func getMockService() -> MockService {
        @Inject(MockServiceKey.self) var service
        return service
    }

    func getMockServiceFactory() -> MockServiceFactoryProtocol {
        @Inject(MockServiceFactoryKey.self) var factory
        return factory
    }
}
