public struct Observable<Event, Scheduler: SchedulerType>: ObservableType {
    static public func unchecked(scheduler: Scheduler, _ factory: @escaping (@escaping (Event) -> Void) -> Disposable) -> Observable {
        return Observable(scheduler: scheduler, factory)
    }

    let factory: (@escaping (Event) -> Void) -> Disposable

    public let scheduler: Scheduler

    private init(scheduler: Scheduler, _ factory: @escaping (@escaping (Event) -> Void) -> Disposable) {
        self.factory = factory
        self.scheduler = scheduler
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable {
        return factory(handler)
    }
}
