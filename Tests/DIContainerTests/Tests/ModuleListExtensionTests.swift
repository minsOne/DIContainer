import Foundation
import Testing
import XCTest

@testable import DIContainer

@MainActor
struct ModuleListExtensionTest {
    @Test
    func replaceOneModule() {
        // Given
        let newModule = Module(MockServiceKey.self) { Service1() }
        var moduleList = ModuleScanner().scanModuleList
        XCTAssertEqual(moduleList.count, 2)

        // When
        moduleList = moduleList.replacing(newModule)

        // Then
        XCTAssertEqual(moduleList.count, 2)
        XCTAssertEqual(moduleList.last?.name, newModule.name)

        let service = moduleList.last?.resolve() as? Service1
        service?.doSomething()
        XCTAssertNotNil(service)
        XCTAssertEqual(service?.count, 1)
    }

    @Test
    func replaceMultipleModules() {
        // Given
        let newModule1 = Module(MockServiceKey.self) { Service1() }
        let newModule2 = Module(WeakMockServiceKey.self) { Service2() }
        var moduleList = ModuleScanner().scanModuleList
        XCTAssertEqual(moduleList.count, 2)

        // When
        moduleList = moduleList.replacing(contentsOf: [newModule1, newModule2])

        // Then
        XCTAssertEqual(moduleList.count, 2)

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service2
            XCTAssertNotNil(module)
            XCTAssertNotNil(service)

            service?.doSomething()
            XCTAssertEqual(module?.name, newModule2.name)
            XCTAssertEqual(service?.count, 1)
        }

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service1
            XCTAssertNotNil(module)
            XCTAssertNotNil(service)

            service?.doSomething()
            XCTAssertEqual(module?.name, newModule1.name)
            XCTAssertEqual(service?.count, 1)
        }
    }
}

private extension ModuleListExtensionTest {
    final class Service1: MockService {
        var count = 0

        func doSomething() {
            count += 1
            print("\(Self.self) doing something... count : \(count)")
        }
    }

    final class Service2: WeakMockService {
        var count = 0

        func doSomething() {
            count += 1
            print("\(Self.self) doing something... count : \(count)")
        }
    }
}
