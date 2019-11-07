public extension Observables {
    static func just<Event>(_ event: Event) -> ScheduledObservable<Event, AllSyncScheduler> {
        return ScheduledObservable.unchecked(scheduler: AllSyncScheduler()) { handler in
            handler(event)
            return DisposableVoid()
        }
    }
}
