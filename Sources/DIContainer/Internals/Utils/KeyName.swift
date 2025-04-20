import Foundation

@MainActor
struct KeyName {
    let name: String
    init<T: InjectionKeyType> (_ type: T.Type) {
        name = type.nameOverride ?? NSStringFromClass(type)
    }
}
