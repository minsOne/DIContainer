import Foundation

struct InjectionKeyHelper {
    static var classPtrInfo: (classesPtr: UnsafeMutablePointer<AnyClass>, numberOfClasses: Int)? {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else { return nil }

        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)

        return (classesPtr, numberOfClasses)
    }

    static var classList: [AnyClass] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

#if DEBUG
        let start = Date()
        defer {
            print("\(Self.self) \(#function)", "Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms", "numberOfClasses : \(numberOfClasses)")
        }
#endif

        return (0 ..< numberOfClasses).map { classesPtr[$0] }
    }

    public static func classes<T>() -> [T.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

#if DEBUG
        let start = Date()
        defer {
            print("\(Self.self) \(#function)", "Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms", "numberOfClasses : \(numberOfClasses)")
        }
#endif

        return (0 ..< numberOfClasses).compactMap { classesPtr[$0] as? T.Type }
    }

    static var keyList: [any InjectionKey.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

#if DEBUG
        let start = Date()
        defer {
            print("\(Self.self) \(#function)", "Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms", "numberOfClasses : \(numberOfClasses)")
        }
#endif

        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any InjectionKey.Type](), [Int]())
        let scanInjectionKeyType = String(cString: class_getName(ScanInjectionKey.self))

        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if let superCls = class_getSuperclass(cls),
               String(cString: class_getName(superCls)) == scanInjectionKeyType,
               case let cls as any InjectionKey.Type = cls
            {
                ptrIndex.append(i)
                keys.append(cls)
            }
        }

//        for i in (firstIndex ..< lastIndex) where String(cString: class_getName(classesPtr[i])).lowercased().contains("key") {
//            if case let cls as any InjectionKey.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }

//        for i in (firstIndex ..< lastIndex) {
//            if case let cls as any InjectionKey.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }

#if DEBUG
        print("InjectionKey classPtr Index : \(ptrIndex)")
#endif
        return keys
    }
#if DEBUG
    static var scanModuleTypeList: [any ScanModuleProtocol.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

        let start = Date()
        defer {
            print("\(Self.self) \(#function)", "Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms", "numberOfClasses : \(numberOfClasses)")
        }
        
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any ScanModuleProtocol.Type](), [Int]())

        let scanModuleType = String(cString: class_getName(ScanModule.self))

        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if let superCls = class_getSuperclass(cls),
               String(cString: class_getName(superCls)) == scanModuleType,
               case let cls as any ScanModuleProtocol.Type = cls
            {
                ptrIndex.append(i)
                keys.append(cls)
            }
        }

//        for i in (firstIndex ..< lastIndex) {
//            if case let cls as any ScanModuleProtocol.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }

        print("InjectionKey classPtr Index : \(ptrIndex)")
        return keys
    }

    static var scanModuleList: [Module] {
        scanModuleTypeList
            .compactMap {
                ($0 as? ScanModule.Type)
                    .map { $0.init() }
                    .flatMap { $0 as? any ScanModuleProtocol & ScanModule }
                    .map { $0.module }
            }
    }
#endif
}
