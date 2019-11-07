internal extension ObservableType {
    func promoteToScheduled<Scheduler: SchedulerType>(_ scheduler: Scheduler) -> ScheduledObservable<Event, Scheduler> {
        return ScheduledObservable.unchecked(scheduler: scheduler, subscribe)
    }
}
