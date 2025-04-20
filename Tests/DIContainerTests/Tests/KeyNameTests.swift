//
//  KeyNameTests.swift
//  DIContainer
//
//  Created by minsOne on 1/26/25.
//

import Testing

@testable import DIContainer

@Suite(.serialized)
@MainActor
struct KeyNameTests {
    @Test
    func compare_1() {
        let lhs = KeyName(NestedType.NestedTypeServiceKey1.self)
        let rhs = KeyName(NestedTypeServiceKey1.self)

        #expect(lhs.name != rhs.name)
    }
    
    @Test
    func compare_2() {
        let lhs = KeyName(NestedType.NestedTypeServiceKey2.self)
        let rhs = KeyName(NestedTypeServiceKey2.self)
        
        #expect(lhs.name == rhs.name)
    }
}

enum NestedType {
    class NestedTypeServiceKey1: InjectionKeyType {
        typealias Value = Void
    }

    class NestedTypeServiceKey2: InjectionKeyType {
        typealias Value = Void
        static var nameOverride: String? { "NestedTypeServiceKey2" }
    }
}

class NestedTypeServiceKey1: InjectionKeyType {
    typealias Value = Void
}

class NestedTypeServiceKey2: InjectionKeyType {
    typealias Value = Void
    static var nameOverride: String? { "NestedTypeServiceKey2" }
}
