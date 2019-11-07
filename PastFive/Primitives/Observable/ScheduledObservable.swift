public struct ScheduledObservable<Event, Scheduler: SchedulerType>: ScheduledObservableType {
    public typealias Unscheduled = Observable<Event>

    static public func unchecked(scheduler: Scheduler, _ subscribe: @escaping Subscribe<Event>) -> Self {
        return Self(scheduler: scheduler, subscribe)
    }

    public let scheduler: Scheduler
    public let unscheduled: Unscheduled

    private init(scheduler: Scheduler, _ subscribe: @escaping Subscribe<Event>) {
        self.unscheduled = Observable(subscribe)
        self.scheduler = scheduler
    }
}
