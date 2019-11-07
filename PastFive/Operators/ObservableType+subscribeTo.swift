public extension ScheduledObservableType {
    func subscribe<Observer: ScheduledObserverType>(to observer: Observer) -> Disposable
        where Observer.Scheduler == Scheduler, Observer.Event == Unscheduled.Event {

            return unscheduled.subscribe(to: observer.unscheduled)
    }
}

public extension ObservableType {
    func subscribe<Observer: ObserverType>(to observer: Observer) -> Disposable
        where Observer.Event == Event {

            return subscribe(observer.handler)
    }
}
