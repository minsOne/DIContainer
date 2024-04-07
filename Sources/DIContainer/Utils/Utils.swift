import Foundation

struct KeyName {
    let name: String
    init(_ type: AnyObject.Type) {
        name = NSStringFromClass(type)
    }
}
