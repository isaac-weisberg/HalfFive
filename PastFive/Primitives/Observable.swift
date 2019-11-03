public struct Observable<Event, Scheduling: SchedulingType>: ObservableType {
    static func unchecked(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) -> Observable {
        return Observable(factory)
    }

    let factory: (@escaping (Event) -> Void) -> Disposable

    private init(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) {
        self.factory = factory
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) -> Disposable {
        return factory(handler)
    }
}

extension Observable: EquitablyScheduledObservableType where Scheduling: EquitableSchedulingType {

}
