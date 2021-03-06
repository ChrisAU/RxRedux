import UIKit

protocol AccessibilityInitializing { }

extension UIView: AccessibilityInitializing { }

extension AccessibilityInitializing where Self: UIView {
    init<T: RawRepresentable>(_ accessibilityIdentifier: T, configureBlock: ((Self) -> ())? = nil) where T.RawValue == String {
        self = Self.init()
        self.accessibilityIdentifier = accessibilityIdentifier.rawValue
        self.isAccessibilityElement = true
        configureBlock?(self)
    }
}
