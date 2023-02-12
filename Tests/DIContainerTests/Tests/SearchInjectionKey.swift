import Foundation
import XCTest

@testable import DIContainer

final class SearchInjectionKeyTests: XCTestCase {
    override func setUp() {
        super.setUp()

        Container {
            Module(MockServiceKey.self) { MockServiceImpl() }
            Module(WeakMockServiceKey.self) { WeakMockServiceImpl() }
        }
        .build()
    }

    func test_SearchInjectKey() {
        let allClassList = Runtime.allClasses()
        let keyList = allClassList.compactMap { $0 as? any InjectionKey.Type }

        print("InjectionKey는 \(keyList.count)개 있습니다")
        print("다음은 InjectionKey 목록입니다.\n\(keyList)")

        for key in keyList {
            let obj: any Any = Container.resolve(for: key)

            if case Optional<Any>.none = obj {
                XCTFail("\(key)가 등록되어 있지 않습니다.")
            }
        }
    }
}
