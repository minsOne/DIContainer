import Foundation
import Testing
import XCTest

@testable import DIContainer

@MainActor
@Suite(.serialized)
class ModuleListExtensionTest {
    var moduleList: [Module]

    init() {
        moduleList = [
            Module(MockServiceFactory.self),
            Module(WeakMockServiceImpl.self),
            Module(MockServiceImpl.self),
        ]
    }
}

extension ModuleListExtensionTest {
    @Test
    func replaceOneModule() {
        // Given
        let newModule = Module(MockServiceKey.self) { Service1() }

        // When
        moduleList = moduleList.replacing(newModule)

        // Then
        #expect(moduleList.count == 3)
        let isContainNewModule = moduleList
            .contains { $0.name == newModule.name }
        #expect(isContainNewModule)

        let service = moduleList.last?.resolve() as? Service1
        service?.doSomething()
        #expect(service != nil)
        #expect(service?.count == 1)
    }

    @Test
    func replaceMultipleModules() {
        // Given
        let newModule1 = Module(MockServiceKey.self) { Service1() }
        let newModule2 = Module(WeakMockServiceKey.self) { Service2() }

        // When
        moduleList = moduleList.replacing(contentsOf: [newModule1, newModule2])

        // Then
        #expect(moduleList.count == 3)

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service2
            #expect(module != nil)
            #expect(service != nil)

            service?.doSomething()
            #expect(module?.name == newModule2.name)
            #expect(service?.count == 1)
        }

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service1
            #expect(module != nil)
            #expect(service != nil)

            service?.doSomething()
            #expect(module?.name == newModule1.name)
            #expect(service?.count == 1)
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
