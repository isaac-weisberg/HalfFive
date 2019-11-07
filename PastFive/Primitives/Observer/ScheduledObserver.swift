public struct ScheduledObserver<Event, Scheduler: SchedulerType>: ScheduledObserverType {
    public typealias Unscheduled = Observer<Event>

    public let unscheduled: Unscheduled

    public init(_ handler: @escaping Handler<Event>) {
        unscheduled = Observer(handler)
    }
}
