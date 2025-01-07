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
struct MachOLoaderTests {
    @Test
    func findAllTypes() {
        #expect(MachOLoader().keyList.count == 2)
        #expect(MachOLoader().scanModuleTypeList.count == 2)
        #expect(MachOLoader().scanModuleList.count == 2)
    }
}

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
