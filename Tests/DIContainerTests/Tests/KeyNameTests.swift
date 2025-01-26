//
//  KeyNameTests.swift
//  DIContainer
//
//  Created by minsOne on 1/26/25.
//

import Testing

@testable import DIContainer

@Suite(.serialized)
struct KeyNameTests {
    @Test
    func compare() {
        let lhs = KeyName(NestedType.NestedTypeServiceKey.self)
        let rhs = KeyName(NestedTypeServiceKey.self)

        #expect(lhs.name != rhs.name)
    }
}

enum NestedType {
    class NestedTypeServiceKey {}
}

class NestedTypeServiceKey {}
