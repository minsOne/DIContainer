import Foundation

@MainActor
public protocol InjectionKeyType: AnyObject {
    associatedtype Value
    
    /// The human-readable name of this key.
    /// This name will be used instead of the type name when a value is printed.
    ///
    /// It MAY also be picked up by an instrument (from Swift Tracing) which serializes context items and e.g. used as
    /// header name for carried metadata. Though generally speaking header names are NOT required to use the nameOverride,
    /// and MAY use their well known names for header names etc, as it depends on the specific transport and instrument used.
    ///
    /// For example, a context key representing the W3C "trace-state" header may want to return "trace-state" here,
    /// in order to achieve a consistent look and feel of this context item throughout logging and tracing systems.
    ///
    /// Defaults to `nil`.
    static var nameOverride: String? { get }
}

extension InjectionKeyType {
    public static var nameOverride: String? { nil }
}

/// DO NOT USE THIS CODE DIRECTLY
open class InjectionBaseKeyType {}

public typealias InjectionKey = InjectionBaseKeyType & InjectionKeyType
