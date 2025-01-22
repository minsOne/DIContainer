//
//  CompareModuleTests.swift
//  DIContainer
//
//  Created by minsOne on 1/23/25.
//

import Testing

@testable import DIContainer

@Suite(.serialized)
struct CompareModuleTests {
    @Test
    func compare() {
        let lhs = Module(MockServiceKey.self) { MockServiceImpl() }
        let rhs = Module(MockServiceImpl.self)
        
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
    }
}
