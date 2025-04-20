//
//  SubscriptTests.swift
//  DIContainer
//
//  Created by minsOne on 4/21/25.
//

import Testing

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct SubscriptTests {
    func registerContainer() {
        // Given
        Container {
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
            Module(MockServiceImpl.self)
            Module(MockServiceFactoryKey.self) { MockServiceFactory() }
        }
        .build()
    }
}

extension SubscriptTests {
    @Test
    func containerRegistration_1() {
        // given
        registerContainer()
        
        // Then
        _ = Container[WeakMockServiceKey.self] as WeakMockService
        _ = Container[MockServiceKey.self] as MockService
        _ = Container[MockServiceFactoryKey.self] as MockServiceFactoryProtocol
    }
    
    @Test
    func containerRegistration_2() {
        // given
        registerContainer()
        
        // Then
        Container[WeakMockServiceKey.self].doSomething()
        Container[MockServiceKey.self].doSomething()
        _ = Container[MockServiceFactoryKey.self].makeService()
        _ = Container[MockServiceFactoryKey.self].makeWeakService()
    }
}
