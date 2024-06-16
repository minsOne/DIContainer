import Foundation
import Testing

@testable import DIContainer

struct ModuleListExtensionTests {
    @Test
    func testReplaceOneModule() {
        // Given
        let newModule = Module(MockServiceKey.self) { Service1() }
        var moduleList = ModuleScanner().scanModuleList
        #expect(moduleList.count == 2)

        // When
        moduleList = moduleList.replacing(newModule)

        // Then
        #expect(moduleList.count == 2)
        #expect(moduleList.last?.name == newModule.name)

        let service = moduleList.last?.resolve() as? Service1
        service?.doSomething()
        #expect(service.isNotNil)
        #expect(service?.count == 1)
    }

    @Test
    func testReplaceMultipleModules() {
        // Given
        let newModule1 = Module(MockServiceKey.self) { Service1() }
        let newModule2 = Module(WeakMockServiceKey.self) { Service2() }
        var moduleList = ModuleScanner().scanModuleList
        #expect(moduleList.count == 2)

        // When
        moduleList = moduleList.replacing(contentsOf: [newModule1, newModule2])

        // Then
        #expect(moduleList.count == 2)

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service2
            #expect(module.isNotNil)
            #expect(service.isNotNil)

            service?.doSomething()
            #expect(module?.name == newModule2.name)
            #expect(service?.count == 1)
        }

        do {
            let module = moduleList.popLast()
            let service = module?.resolve() as? Service1
            #expect(module.isNotNil)
            #expect(service.isNotNil)

            service?.doSomething()
            #expect(module?.name == newModule1.name)
            #expect(service?.count == 1)
        }
    }
}

private extension ModuleListExtensionTests {
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
