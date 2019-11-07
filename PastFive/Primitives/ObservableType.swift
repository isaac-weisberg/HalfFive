public protocol ObservableType {
    associatedtype Event
    associatedtype Scheduler: SchedulerType

    var scheduler: Scheduler { get }

    func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable
}

public extension ObservableType {
    func subscribe<Observer: ObserverType>(to observer: Observer) -> Disposable
        where Observer.Scheduler == Scheduler, Observer.Event == Event {
            
        return subscribe(observer.handle(event:))
    }
}
