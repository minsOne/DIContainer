//
//  MachOLoader.swift
//  DIContainer
//
//  Created by minsOne on 12/10/24.
//
// Reference : https://github.com/eure/Storybook-ios/blob/main/Sources/StorybookKit/Internals/machOLoader.swift

#if DEBUG

import Foundation
import MachO

public struct MachOLoader {
    public init() {}
}

public extension MachOLoader {
    var keyList: [any InjectionKeyType.Type] {
        let start = Date()
        var results: [any InjectionKeyType.Type] = []
        for imageIndex in 0 ..< _dyld_image_count() {
            findAllInjectionKeyType(
                inImageIndex: .init(imageIndex),
                results: &results
            )
        }

        print("""
        ┌───── \(Self.self) \(#function) ──────
        │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
        │ InjectionKey List :
        │  - \(results)
        └────────────────────────────────────────────────
        """)

        return results
    }

    var scanModuleTypeList: [any AutoModulable.Type] {
        let start = Date()
        var results: [any AutoModulable.Type] = []
        for imageIndex in 0 ..< _dyld_image_count() {
            findAllModuleType(
                inImageIndex: .init(imageIndex),
                results: &results
            )
        }

        print("""
        ┌───── \(Self.self) \(#function) ─────────
        │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
        │ AutoModule List :
        │  - \(results)
        └────────────────────────────────────────────────
        """)

        return results
    }

    var scanModuleList: [Module] {
        scanModuleTypeList
            .compactMap { ($0 as? any AutoModule.Type)?.module }
    }
}

private extension MachOLoader {
    func findAnyClassTypes(
        inImageIndex imageIndex: UInt32,
        results: inout [any AnyObject.Type]
    ) {
        // Follows same approach here:  https://github.com/apple/swift-testing/blob/main/Sources/TestingInternals/Discovery.cpp#L318
        let imageName = String(cString: _dyld_get_image_name(imageIndex))
        if isSystemImage(imageName) { return }

        let headerRawPtr = _dyld_get_image_header(imageIndex)
            .map(UnsafeRawPointer.init(_:))
        guard let headerRawPtr else { return }

        let headerPtr = headerRawPtr.assumingMemoryBound(
            to: mach_header_64.self
        )

        // https://derekselander.github.io/dsdump/
        var size: UInt = 0
        let sectionRawPtr = getsectiondata(
            headerPtr, SEG_TEXT, "__swift5_types", &size
        ).map { UnsafeRawPointer($0) }
        guard let sectionRawPtr else { return }

        let capacity: Int = .init(size) / MemoryLayout<SwiftTypeMetadataRecord>.size
        let sectionPtr = sectionRawPtr.assumingMemoryBound(
            to: SwiftTypeMetadataRecord.self
        )
        for index in 0 ..< capacity {
            let record = sectionPtr.advanced(by: index)
            guard
                let contextDescriptor = record.pointee.contextDescriptor(
                    from: record
                ),
                !contextDescriptor.pointee.isGeneric(),
                case .classType = contextDescriptor.pointee.kind(),
                case let metadataClosure = contextDescriptor.resolveValue(for: \.metadataAccessFunction),
                case let metadata = metadataClosure(0xFF),
                let metadataAccessFunction = metadata.value
            else {
                continue
            }

            let cls: AnyClass = unsafeBitCast(
                metadataAccessFunction,
                to: AnyClass.Type.self
            )

            results.append(cls)
        }
    }

    func findAllInjectionKeyType(
        inImageIndex imageIndex: UInt32,
        results: inout [any InjectionKeyType.Type]
    ) {
        var clsList: [any AnyObject.Type] = []
        findAnyClassTypes(inImageIndex: imageIndex, results: &clsList)
        for cls in clsList {
            let superCls = InjectionBaseKeyType.self
            guard
                class_getSuperclass(cls) == superCls,
                case let kcls as any InjectionKeyType.Type = cls
            else { continue }

            results.append(kcls)
        }
    }

    func findAllModuleType(
        inImageIndex imageIndex: UInt32,
        results: inout [any AutoModulable.Type]
    ) {
        var clsList: [any AnyObject.Type] = []
        findAnyClassTypes(inImageIndex: imageIndex, results: &clsList)

        for cls in clsList {
            let superCls = AutoModuleBase.self
            guard
                class_getSuperclass(cls) == superCls,
                case let kcls as any AutoModulable.Type = cls
            else { continue }

            results.append(kcls)
        }
    }
}

private extension UnsafePointer where Pointee: SwiftLayoutPointer {
    func resolvePointer<U>(for keyPath: KeyPath<Pointee, SwiftRelativePointer<U>>) -> UnsafePointer<U> {
        let base: UnsafeRawPointer = .init(self)
        let fieldOffset = MemoryLayout<Pointee>.offset(of: keyPath)!
        let relativePointer = pointee[keyPath: keyPath]
        return base
            .advanced(by: fieldOffset)
            .advanced(by: .init(relativePointer.offset))
            .assumingMemoryBound(to: U.self)
    }

    func resolveValue<U>(for keyPath: KeyPath<Pointee, SwiftRelativePointer<U>>) -> U {
        let base: UnsafeRawPointer = .init(self)
        let fieldOffset = MemoryLayout<Pointee>.offset(of: keyPath)!
        let relativePointer = pointee[keyPath: keyPath]
        let pointer = base
            .advanced(by: fieldOffset)
            .advanced(by: .init(relativePointer.offset))
        return unsafeBitCast(pointer, to: U.self)
    }
}

private extension UnsafePointer where Pointee == SwiftTypeContextDescriptor {
    func nameContains(_ string: String) -> Bool {
        string.withCString(
            {
                let nameCString = self.resolvePointer(for: \.name)
                return strstr(nameCString, $0) != nil
            }
        )
    }
}

private protocol SwiftLayoutPointer {
    static var maskValue: Int32 { get }
}

private extension SwiftLayoutPointer {
    static var maskValue: Int32 { 0 }
}

private struct SwiftRelativePointer<T> {
    var offset: Int32 = 0

    func pointer(
        from base: UnsafeRawPointer,
        vmAddrSlide: Int
    ) -> UnsafePointer<T>? {
        let maskedOffset: Int = .init(offset)
        guard maskedOffset != 0 else { return nil }

        return base
            .advanced(by: -vmAddrSlide)
            .advanced(by: maskedOffset)
            .assumingMemoryBound(to: T.self)
    }
}

extension SwiftRelativePointer where T: SwiftLayoutPointer {
    func value() -> Int32 {
        offset & T.maskValue
    }

    func pointer(
        from base: UnsafeRawPointer
    ) -> UnsafePointer<T>? {
        let maskedOffset: Int = .init(offset & ~T.maskValue)
        guard maskedOffset != 0 else {
            return nil
        }
        return base
            .advanced(by: maskedOffset)
            .assumingMemoryBound(to: T.self)
    }
}

private struct SwiftTypeMetadataRecord: SwiftLayoutPointer {
    var pointer: SwiftRelativePointer<SwiftTypeContextDescriptor>

    func contextDescriptor(
        from base: UnsafeRawPointer
    ) -> UnsafePointer<SwiftTypeContextDescriptor>? {
        switch pointer.value() {
        case 0:
            return pointer.pointer(from: base)

        case 1:
            // Untested
            return pointer.pointer(from: base).map {
                let indirection: UnsafeRawPointer = .init($0)
                return indirection
                    .assumingMemoryBound(to: UnsafePointer<SwiftTypeContextDescriptor>.self)
                    .pointee
            }

        default:
            return nil
        }
    }
}

private struct SwiftTypeContextDescriptor: SwiftLayoutPointer {
    var flags: UInt32 = 0
    var parent: SwiftRelativePointer<UInt8> = .init()
    var name: SwiftRelativePointer<CChar> = .init()
    var metadataAccessFunction: SwiftRelativePointer < (@convention(thin) (Int) -> MetadataAccessResponse)> = .init()

    func isGeneric() -> Bool {
        (flags & 0x80) != 0
    }

    func kind() -> Kind {
        // https://github.com/blacktop/go-macho/blob/master/types/swift/types.go#L589
        .init(rawValue: flags & 0x1F)
    }

    struct MetadataAccessResponse: SwiftLayoutPointer {
        var value: UnsafeRawPointer?
        var state: Int = 0
    }

    static let maskValue: Int32 = .init(MemoryLayout<Int32>.alignment - 1)

    struct Kind: RawRepresentable, Equatable {
        static let module: Self = .init(rawValue: 0)
        static let `extension`: Self = .init(rawValue: 1)
        static let anonymous: Self = .init(rawValue: 2)
        static let `protocol`: Self = .init(rawValue: 3)
        static let opaqueType: Self = .init(rawValue: 4)

        static let typesStart: Self = .init(rawValue: 16)

        static let classType: Self = .init(rawValue: Self.typesStart.rawValue)
        static let structType: Self = .init(rawValue: Self.typesStart.rawValue + 1)
        static let enumType: Self = .init(rawValue: Self.typesStart.rawValue + 2)

        static let typesEnd: Self = .init(rawValue: 31)

        let rawValue: UInt32

        init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        var canConformToProtocol: Bool {
            (Self.typesStart.rawValue ... Self.typesEnd.rawValue).contains(rawValue)
        }
    }
}

#endif
