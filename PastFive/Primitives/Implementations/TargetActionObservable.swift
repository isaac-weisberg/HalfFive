import UIKit

public class TargetActionObservable<Event, Control: UIControl>: ObservableType {
    public init(control: Control, event: UIControl.Event, _ transform: @escaping (Control, UIControl.Event) -> Event) {
        subscribe = { handler in
            return TargetSink(control, event: event) { [control, event, transform] in
                let actualEvent = transform(control, event)
                handler(actualEvent)
            }
        }
    }

    public let subscribe: Subscribe<Event>
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
