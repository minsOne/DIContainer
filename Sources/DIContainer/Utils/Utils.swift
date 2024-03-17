import Foundation

struct Utils {
    func keyName(_ type: AnyObject.Type) -> String {
        NSStringFromClass(type)
    }
}
