import UIKit
import PastFive

extension UIButton: ReactiveHost { }

extension Reactive where Base: UIButton {
    var tap: ScheduledObservable<Void, MainScheduler> {
        return TargetActionObservable(
            control: base,
            event: .touchUpInside,
            scheduler: MainScheduler()) { _, _ in
                ()

        }
        .eraseType()
    }
}
