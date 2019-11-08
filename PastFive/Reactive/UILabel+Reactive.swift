import UIKit

extension UILabel: ReactiveHost { }

public extension Reactive where Base: UILabel {
    var text: ScheduledObserver<String, MainScheduler> {
        return ScheduledObserver { [base] text in
            base.text = text
        }
    }
}
