//
//  DIContainerExampleTests.swift
//  DIContainerExampleTests
//
//  Created by minsOne on 6/2/24.
//

import XCTest

@testable import DIContainer
@testable import DIContainerExample

final class DIContainerExampleTests: XCTestCase {
    func testContainer() {
        let scanner = ModuleScanner()
        RegisterContainer().setup()

        XCTAssertEqual(scanner.keyList.count,
                       Container.root.modules.keys.count)
        XCTAssertEqual(scanner.scanModuleList.count,
                       Container.root.modules.keys.count)
    }
}
