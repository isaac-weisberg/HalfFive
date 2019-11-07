public protocol ScheduledObserverType {
    associatedtype Unscheduled: ObserverType
    associatedtype Scheduler: SchedulerType

    var unscheduled: Unscheduled { get }
}

public extension ScheduledObserverType {
    typealias Event = Unscheduled.Event

    var handler: Handler<Event> {
        return unscheduled.handler
    }
}
