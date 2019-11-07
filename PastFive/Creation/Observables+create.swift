public extension Observables {
    static func create<Event>(subscribe: @escaping Subscribe<Event>)
        -> Observable<Event> {

        return Observable(subscribe)
    }
}
