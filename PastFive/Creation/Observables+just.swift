public extension Observables {
    static func just<Event>(_ event: Event) -> Observable<Event, AllSyncRunner> {
        return Observable.unchecked { handler in
            handler(event)
            return DiposableVoid()
        }
    }
}
