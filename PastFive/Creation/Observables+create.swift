public extension Observables {
    static func create<Event>(factory: @escaping (@escaping (Event) -> Void) -> Disposable)
        -> Observable<Event, SomeSyncRunner> {

        return Observable.unchecked(factory)
    }
}
