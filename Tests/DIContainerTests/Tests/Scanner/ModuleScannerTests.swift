import Foundation
import MockData
import Testing
import XCTest

@testable import DIContainer

@MainActor
@Suite(.serialized)
struct ModuleScannerTest {}

extension ModuleScannerTest {
    @Test
    func scanInjectKeys() {
        Container {
            Module(MockServiceKey.self) { MockServiceImpl() }
            Module(WeakMockServiceImpl.self)
            Module(MockServiceFactory.self)
        }
        .build()

        let keyList = ModuleScanner().keyList

        print("""
        ┌───── \(Self.self) \(#function) ──────────────
        │ InjectionKey는 \(keyList.count)개 있습니다.
        │ 다음은 InjectionKey 목록입니다.
          \(dump(keyList))
        └────────────────────────────────────────────────
        """)

        #expect(keyList.isEmpty == false)
        #expect(keyList.count == 3)

        for key in keyList {
            let obj: any Any = Container.resolve(for: key)

            if case Optional<Any>.none = obj {
                assertionFailure("\(key)가 등록되어 있지 않습니다.")
            }
        }
    }

    @Test
    func scanModules() {
        let moduleList = ModuleScanner().scanModuleList

        print("""
        ┌───── \(Self.self) \(#function) ─────────
        │ Module는 \(moduleList.count)개 있습니다.
        │ 다음은 Module 목록입니다.
          - \(dump(moduleList))
        └────────────────────────────────────────────────
        """)

        #expect(moduleList.isEmpty == false)
        #expect(moduleList.count == 3)

        Container(modules: moduleList)
            .build()

        do {
            @Inject(MockServiceKey.self) var service
            service.doSomething()
        }

        do {
            @WeakInject(WeakMockServiceKey.self) var service
            service?.doSomething()
        }
    }
}

extension ModuleScannerTest {
    @Test
    func generateNewInstanceFromContainer() throws {
        Container.autoRegisterModules()

        let _service1 = getMockService()
        let _service2 = getMockService()

        _service1.doSomething()
        let service1 = try #require(_service1 as? MockServiceImpl)
        #expect(service1.count == 1)

        _service2.doSomething()
        let service2 = try #require(_service2 as? MockServiceImpl)
        #expect(service2.count == 1)

        #expect((service1 === service2) == false)
    }
    
    func getMockService() -> MockService {
        @Inject(MockServiceKey.self) var service
        return service
    }
}
