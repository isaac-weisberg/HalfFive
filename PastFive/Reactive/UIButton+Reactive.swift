import UIKit

extension UIButton: ReactiveHost { }

public extension Reactive where Base: UIButton {
    var tap: ScheduledObservable<Void, MainScheduler> {
        return TargetActionObservable(
            control: base,
            event: .touchUpInside) { _, _ in
                ()
            }
            .eraseType()
            .promoteToScheduled(MainScheduler.instance)
    }
}
