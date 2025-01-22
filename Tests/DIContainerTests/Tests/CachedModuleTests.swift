//
//  CachedModuleTests.swift
//  DIContainer
//
//  Created by minsOne on 1/23/25.
//

import Testing

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct CachedModuleTests {
    init() {
        Container.autoRegisterModules()
    }
}

extension CachedModuleTests {
    @Test
    func cachedModule() throws {
        let service1 = getMockService()
        let service2 = getMockService()

        service1.doSomething()
        do {
            let service = try #require(service1 as? MockServiceImpl)
            #expect(service.count == 1)
        }

        service2.doSomething()
        do {
            let service = try #require(service2 as? MockServiceImpl)
            #expect(service.count == 2)
        }
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

extension CachedModuleTests {
    func getMockService() -> MockService {
        @Inject(MockServiceKey.self) var service
        return service
    }

    func getMockServiceFactory() -> MockServiceFactoryProtocol {
        @Inject(MockServiceFactoryKey.self) var factory
        return factory
    }
}
