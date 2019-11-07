import UIKit
import PastFive

class TargetActionObservable<Event, Scheduler: SchedulerType, Control: UIControl>: ObservableType {
    let scheduler: Scheduler
    let control: Control
    let event: UIControl.Event
    let transform: (Control, UIControl.Event) -> Event

    init(control: Control, event: UIControl.Event, scheduler: Scheduler, _ transfrom: @escaping (Control, UIControl.Event) -> Event) {
        self.scheduler = scheduler
        self.control = control
        self.event = event
        self.transform = transfrom
    }

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable {
        return TargetSink(control, event: event) { [control, event, transform] in
            let actualEvent = transform(control, event)
            handler(actualEvent)
        }
    }
}

private class TargetSink<Control: UIControl>: NSObject, Disposable {
    init(_ control: Control, event: UIControl.Event, handler: @escaping () -> Void) {
        self.control = control
        self.event = event
        self.handler = handler
        super.init()
        control.addTarget(self, action: #selector(handleEvent), for: event)
    }

    let control: Control
    let event: UIControl.Event

    let handler: () -> Void

    @objc func handleEvent() {
        handler()
    }

    deinit {
        control.removeTarget(self, action: #selector(handleEvent), for: event)
    }
}
