public extension Observables {
    static func combineLatest<
        Event,
        First: EquitablyScheduledObservableType,
        Second: EquitablyScheduledObservableType
    >
        (_ first: First, second: Second, _ transform: @escaping (First.Event, Second.Event) -> Event)
        -> Observable<Event, First.Scheduling>
        where First.Scheduling == Second.Scheduling {

        return Observable.unchecked { handler in
            let disposable = CombinedDisposable<First.Event, Second.Event>()

            disposable.first = first.subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                disposable.state.first = event
                disposable.state.getEventsIfTheyAreThere { first, second in
                    let newEvent = transform(first, second)
                    handler(newEvent)
                }
            }

            disposable.second = second.subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                disposable.state.second = event
                disposable.state.getEventsIfTheyAreThere { first, second in
                    let newEvent = transform(first, second)
                    handler(newEvent)
                }
            }

            return disposable
        }
    }
}

private class CombinedDisposable<First, Second>: Disposable {
    var first: Disposable?
    var second: Disposable?
    var state = CombinedState<First, Second>()
}

private struct CombinedState<First, Second> {
    var first: First?
    var second: Second?

    func getEventsIfTheyAreThere(_ getter: (First, Second) -> Void) {
        guard
            let first = first,
            let second = second else {
                return
        }
        getter(first, second)
    }
}
