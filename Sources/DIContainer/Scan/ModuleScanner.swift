import Foundation

public struct ModuleScanner {
    init() {}
    var classPtrInfo: (classesPtr: UnsafeMutablePointer<AnyClass>, numberOfClasses: Int)? {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else { return nil }

        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)

        return (classesPtr, numberOfClasses)
    }

    var classList: [AnyClass] {
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

    public func classes<T>() -> [T.Type] {
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

    var keyList: [any InjectionKey.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any InjectionKey.Type](), [Int]())
        let superCls = InjectionKeyScanType.self

// MARK: Case 1 - class_getSuperclass
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any InjectionKey.Type = cls
            {
                ptrIndex.append(i)
                keys.append(kcls)
            }
        }

// MARK: Case 2 - class_getInstanceVariable
//        let key = "injectKey"
//        for i in firstIndex ..< lastIndex {
//            let cls: AnyClass = classesPtr[i]
//            if let _ = class_getInstanceVariable(cls, key),
//               case let kcls as any InjectionKey.Type = cls
//            {
//                ptrIndex.append(i)
//                keys.append(kcls)
//            }
//        }

// MARK: Case 3 class_getName
//        for i in firstIndex ..< lastIndex where String(cString: class_getName(classesPtr[i])).lowercased().contains("key") {
//            if case let cls as any InjectionKey.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }

// MARK: Case 4 Casting
//        for i in firstIndex ..< lastIndex {
//            if case let cls as any InjectionKey.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }


#if DEBUG
        print("\n┌─────\(Self.self) \(#function)─────────────────────")
        print("│Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms")
        print("│numberOfClasses : \(numberOfClasses)")
        print("│InjectionKey classPtr Index : \(ptrIndex)")
        print("│InjectionModulable List :")
        print("│ - \(keys)")
        print("└────────────────────────────────────────────────\n")
#endif
        return keys
    }

    var scanModuleTypeList: [any InjectionModulable.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any InjectionModulable.Type](), [Int]())
        let superCls = InjectionModuleScanType.self

// MARK: Case 1 - class_getSuperclass
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any InjectionModulable.Type = cls {
                ptrIndex.append(i)
                keys.append(kcls)
            }
        }

// MARK: Case 2 - class_getInstanceVariable
//        let key = "injectKey"
//        for i in firstIndex ..< lastIndex {
//            let cls: AnyClass = classesPtr[i]
//            if let _ = class_getInstanceVariable(cls, key),
//               case let kcls as any InjectionModulable.Type = cls {
//                ptrIndex.append(i)
//                keys.append(kcls)
//            }
//        }

// MARK: Case 3 - Casting
//        for i in (firstIndex ..< lastIndex) {
//            if case let cls as any InjectionModulable.Type = classesPtr[i] {
//                ptrIndex.append(i)
//                keys.append(cls)
//            }
//        }


#if DEBUG
        print("\n┌─────\(Self.self) \(#function)─────────────────────")
        print("│Duration : ", (Date().timeIntervalSince(start) * 1000).rounded(), "ms")
        print("│numberOfClasses : \(numberOfClasses)")
        print("│InjectionKey classPtr Index List : \(ptrIndex)")
        print("│InjectionModulable List :")
        print("│ - \(keys)")
        print("└────────────────────────────────────────────────\n")
#endif
        
        return keys
    }

    var scanModuleList: [Module] {
        return scanModuleTypeList
            .compactMap { ($0 as? any InjectionModule.Type)?.init().module }
    }
}
