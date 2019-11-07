public protocol ScheduledObservableType {
    associatedtype Unscheduled: ObservableType

    associatedtype Scheduler: SchedulerType

    var unscheduled: Unscheduled { get }

    var scheduler: Scheduler { get }
}

public extension ScheduledObservableType {
    typealias Event = Unscheduled.Event

    var subscribe: Subscribe<Event> {
        return unscheduled.subscribe
    }
}
