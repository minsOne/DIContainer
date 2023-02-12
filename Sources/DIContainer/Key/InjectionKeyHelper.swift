#if DEBUG
import Foundation

struct InjectionKeyHelper {
    static var classList: [AnyClass] {
        let start = Date()
        defer { print("Duration : \( (Date().timeIntervalSince(start) * 1000).rounded() )ms") }
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

    static var keyList: [any InjectionKey.Type] {
        classList.compactMap { $0 as? any InjectionKey.Type }
    }
    static var autoRegisterModuleList: [any AutoRegisterModuleProtocol.Type] {
        classList.compactMap { $0 as? any AutoRegisterModuleProtocol.Type }
    }
}
#endif

