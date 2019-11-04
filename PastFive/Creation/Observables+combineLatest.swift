public extension Observables {
    static func combineLatest
    <
        Event,
        First: EquitablyScheduledObservableType,
        Second: EquitablyScheduledObservableType
    >
    (
        _ first: First,
        _ second: Second,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    )
    -> Observable<Event, First.Scheduler>
        where First.Scheduler == Second.Scheduler,
        First.Scheduler.EquityProof == Second.Scheduler.EquityProof {

            #if !DISABLE_EQUITY_DYNAMIC_VALIDATION
            guard first.scheduler == second.scheduler else {
                fatalError(
                    """
                        > The equity was proven statically
                        > but you've used different scheduler
                        > instances anyway, dumbass
                        >
                        > Either remove the equity or
                        > Use only the same scheduler instance
                        > for both observables
                    """
                )
            }
            #endif

            return Observable.unchecked(scheduler: first.scheduler) { handler in
            let disposable = CombinedDisposable<First.Event, Second.Event>()

            disposable.first = first.subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                disposable.state.mutate { state in
                    state.first = event
                }
                disposable.state.read().getEventsIfTheyAreThere { first, second in
                    let newEvent = transform(first, second)
                    handler(newEvent)
                }
            }

            disposable.second = second.subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                disposable.state.mutate { state in
                    state.second = event
                }
                disposable.state.read().getEventsIfTheyAreThere { first, second in
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
    var state = MutexUnsafe(value: CombinedState<First, Second>())
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
