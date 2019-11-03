public struct Observable<Event, Scheduling: SchedulingType>: ObservableType {
    let factory: (@escaping (Event) -> Void) -> Disposable

    init(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) {
        self.factory = factory
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable {
        return factory(handler)
    }
}
