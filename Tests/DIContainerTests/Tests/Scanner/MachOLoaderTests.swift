//
//  MachOLoaderTests.swift
//  DIContainer
//
//  Created by minsOne on 1/7/25.
//

@testable import DIContainer

import Foundation
import Testing
import XCTest

@MainActor
@Suite(.serialized)
struct MachOLoaderTests {}

extension MachOLoaderTests {
    @Test
    func findAllTypes() {
        #expect(MachOLoader().keyList.count == 3)
        #expect(MachOLoader().scanModuleTypeList.count == 3)
        #expect(MachOLoader().scanModuleList.count == 3)
    }
}

/**
class ScannerPerformanceTests: XCTestCase {
    func test_MachOLoader() {
        measure {
            _ = MachOLoader().keyList
            _ = MachOLoader().scanModuleTypeList
        }
    }

    func test_ModuleScanner() {
        measure {
            _ = ModuleScanner().keyList
            _ = ModuleScanner().scanModuleTypeList
        }
    }
}
*/
