public extension ScheduledObservableType {
    func eraseType() -> ScheduledObservable<Event, Scheduler> {
        return ScheduledObservable.unchecked(scheduler: scheduler, subscribe)
    }
}

public extension ObservableType {
    func eraseType() -> Observable<Event> {
        return Observable(subscribe)
    }
}
