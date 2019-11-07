public extension ScheduledObservableType {
    func map<NewEvent>(_ transform: @escaping (Event) -> NewEvent) -> ScheduledObservable<NewEvent, Scheduler> {
        return unscheduled.map(transform)
            .promoteToScheduled(scheduler)
    }
}

public extension ObservableType {
    func map<NewEvent>(_ transform: @escaping (Event) -> NewEvent) -> Observable<NewEvent> {
        return Observable { [subscribe] handler in
            return subscribe { event in
                handler(transform(event))
            }
        }
    }
}
