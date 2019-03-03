import UIKit

extension UIView {
    var isShown: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}
