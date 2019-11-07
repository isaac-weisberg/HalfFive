import UIKit
import PastFive

extension UILabel: ReactiveHost { }

extension Reactive where Base: UILabel {
    var text: Observer<String, MainScheduler> {
        return Observer { [base] text in
            base.text = text
        }
    }
}
