import Foundation

@MainActor
@propertyWrapper
public class Inject<Value> {
    private let lazyValue: () -> Value
    private var storage: Value?

    public var wrappedValue: Value {
        storage ?? {
            let value: Value = lazyValue()
            storage = value // Reuse instance for later
            return value
        }()
    }

    public init<K>(_ key: K.Type) where K: InjectionKeyType, Value == K.Value {
        lazyValue = {
            Container.resolve(for: K.self)
        }
    }
}
