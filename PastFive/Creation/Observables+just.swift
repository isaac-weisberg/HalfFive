public extension Observables {
    static func just<Event>(_ event: Event) -> Observable<Event, AllSyncScheduler> {
        return Observable.unchecked(scheduler: AllSyncScheduler()) { handler in
            handler(event)
            return DiposableVoid()
        }
    }
}
