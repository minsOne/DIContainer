import Foundation

@testable import DIContainer

extension InjectionKey {
    static var module: Module? {
        Container.root.modules[String(describing: Self.self)]
    }
}

class Runtime {
    static func allClasses() -> [AnyClass] {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else { return [] }

        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)
        defer { classesPtr.deallocate() }
        let classes = (0 ..< numberOfClasses).map { classesPtr[$0] }
        return classes
    }
}
