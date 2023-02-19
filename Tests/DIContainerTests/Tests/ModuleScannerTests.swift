import Foundation
import MockData
import XCTest

@testable import DIContainer

final class ModuleScannerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func test_ScanInjectKeys() {
        Container {
            Module(MockServiceKey.self) { MockServiceImpl() }
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
        }
        .build()

        let keyList = ModuleScanner().keyList

        print("\n┌─────\(Self.self) \(#function)─────────────────────")
        print("│InjectionKey는 \(keyList.count)개 있습니다")
        print("│다음은 InjectionKey 목록입니다.")
        print("│ - \(keyList)")
        print("└────────────────────────────────────────────────\n")
        XCTAssertEqual(keyList.isEmpty, false)
        XCTAssertEqual(keyList.count, 2)

        for key in keyList {
            let obj: any Any = Container.resolve(for: key)

            if case Optional<Any>.none = obj {
                XCTFail("\(key)가 등록되어 있지 않습니다.")
            }
        }
    }

    func test_ScanModules() {
        let moduleList = ModuleScanner().scanModuleList

        print("\n┌─────\(Self.self) \(#function)─────────────────────")
        print("│Module는 \(moduleList.count)개 있습니다.")
        print("│다음은 Module 목록입니다.")
        print("│ - \(moduleList)")
        print("└────────────────────────────────────────────────\n")

        XCTAssertEqual(moduleList.isEmpty, false)
        XCTAssertEqual(moduleList.count, 2)

        Container(modules: moduleList)
            .build()

        do {
            @Inject(MockServiceKey.self) var service;
            service.doSomething()
        }

        do {
            @WeakInject(WeakMockServiceKey.self) var service;
            service?.doSomething()
        }
    }
}
