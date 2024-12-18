import Foundation
import MockData
import Testing
import XCTest

@testable import DIContainer

@MainActor
struct ModuleScannerTest {
    @Test
    func scanInjectKeys() {
        Container {
            Module(MockServiceKey.self) { MockServiceImpl() }
            Module(WeakMockServiceImpl.self)
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

        XCTAssertEqual(keyList.isEmpty, false)
        XCTAssertEqual(keyList.count, 2)

        for key in keyList {
            let obj: any Any = Container.resolve(for: key)

            if case Optional<Any>.none = obj {
                XCTFail("\(key)가 등록되어 있지 않습니다.")
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

        XCTAssertEqual(moduleList.isEmpty, false)
        XCTAssertEqual(moduleList.count, 2)

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
