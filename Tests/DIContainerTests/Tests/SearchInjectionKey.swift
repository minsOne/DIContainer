import Foundation
import XCTest

@testable import DIContainer

final class SearchInjectionKeyTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func test_SearchInjectKey() {
        Container {
            Module(MockServiceKey.self) { MockServiceImpl() }
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
        }
        .build()

        let keyList = InjectionKeyHelper.keyList

        print("InjectionKey는 \(keyList.count)개 있습니다")
        print("다음은 InjectionKey 목록입니다.\n\(keyList)")

        for key in keyList {
            let obj: any Any = Container.resolve(for: key)

            if case Optional<Any>.none = obj {
                XCTFail("\(key)가 등록되어 있지 않습니다.")
            }
        }
    }

    func test_AutoRegisterModule() {
        let moduleList = InjectionKeyHelper.autoRegisterModuleList
            .map { $0.module }

        Container(modules: moduleList)
            .build()

        @Inject(MockServiceKey.self) var service1;
        service1.doSomething()
        service1.doSomething()
        @WeakInject(WeakMockServiceKey.self) var service2;
        service2?.doSomething()
        service2?.doSomething()
        service2?.doSomething()
    }
}
