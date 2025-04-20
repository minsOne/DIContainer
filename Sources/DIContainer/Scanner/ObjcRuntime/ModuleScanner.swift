import Foundation
import ObjectiveC.runtime

#if DEBUG
public struct ModuleScanner {
    public init() {}

    var classPtrInfo: (classesPtr: UnsafeMutablePointer<AnyClass>, numberOfClasses: Int)? {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else { return nil }

        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)

        return (classesPtr, numberOfClasses)
    }

    public var keyList: [any InjectionKeyType.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any InjectionKeyType.Type](), [Int]())
        let superCls = InjectionBaseKeyType.self

// MARK: Case 1 - class_getSuperclass
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any InjectionKeyType.Type = cls {
                ptrIndex.append(i)
                keys.append(kcls)
            }
        }

// MARK: Case 2 - class_getInstanceVariable
//        let key = "injectKey"
//        for i in firstIndex ..< lastIndex {
//            let cls: AnyClass = classesPtr[i]
//            if let _ = class_getInstanceVariable(cls, key),
//               case let kcls as any InjectionKey.Type = cls {
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

        print("""
        ┌───── \(Self.self) \(#function) ──────
        │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
        │ numberOfClasses : \(numberOfClasses)
        │ InjectionKey classPtr Index : \(ptrIndex)
        │ InjectionKey List :
        │  - \(keys)
        └────────────────────────────────────────────────
        """)
        return keys
    }

    public var scanModuleTypeList: [any AutoModulable.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else { return [] }
        defer { classesPtr.deallocate() }

        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (modules, ptrIndex) = ([any AutoModulable.Type](), [Int]())
        let superCls = AutoModuleBase.self

// MARK: Case 1 - class_getSuperclass
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any AutoModulable.Type = cls {
                ptrIndex.append(i)
                modules.append(kcls)
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

        print("""
        ┌───── \(Self.self) \(#function) ─────────
        │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
        │ numberOfClasses : \(numberOfClasses)
        │ InjectionKey classPtr Index List : \(ptrIndex)
        │ AutoModule List :
        │  - \(modules)
        └────────────────────────────────────────────────
        """)

        return modules
    }

    @MainActor
    public var scanModuleList: [Module] {
        scanModuleTypeList
            .compactMap { ($0 as? any AutoModule.Type)?.module }
    }
}
#endif

#if DEBUG
public extension Container {
    @MainActor
    static func autoRegisterModules() {
        let moduleList = ModuleScanner().scanModuleList
        Container(modules: moduleList).build()
    }
}
#endif
