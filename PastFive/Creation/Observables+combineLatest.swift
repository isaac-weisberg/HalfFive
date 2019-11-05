public extension Observables {
    static func combineLatest
        <
            Event,
            First: ObservableType,
            Second: ObservableType
        >
        (
            _ first: First,
            _ second: Second,
            _ tranform: @escaping (First.Event, Second.Event) -> Event
        )
        -> Observable<Event, RandomScheduler> {

            return combineLatestUnsafe(first, second, RandomScheduler(), Mutex.self, tranform)
    }

    static func combineLatest
        <
            Event,
            First: ObservableType,
            Second: ObservableType
        >
        (
            _ first: First,
            _ second: Second,
            _ tranform: @escaping (First.Event, Second.Event) -> Event
        )
        -> Observable<Event, First.Scheduler>
        where First.Scheduler == Second.Scheduler, First.Scheduler: SynchronizedScheduler {

            if first.scheduler == second.scheduler {
                return combineLatestUnsafe(first, second, first.scheduler, MutexUnsafe.self, tranform)
            }
            return combineLatestUnsafe(first, second, first.scheduler, Mutex.self, tranform)
    }


    static private func combineLatestUnsafe
    <
        Event,
        First: ObservableType,
        Second: ObservableType,
        Scheduler: SchedulerType,
        Mutex: MutexType
    >
    (
        _ first: First,
        _ second: Second,
        _ scheduler: Scheduler,
        _ mutexType: Mutex.Type,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    )
    -> Observable<Event, Scheduler>
        where Mutex.Value == CombinedState<First.Event, Second.Event> {

        return Observable.unchecked(scheduler: scheduler) { handler in
            let disposable = CombinedDisposable<First.Event, Second.Event, Mutex>()

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

private class CombinedDisposable<First, Second, Mutex: MutexType>: Disposable
                    where Mutex.Value == CombinedState<First, Second> {

    var first: Disposable?
    var second: Disposable?
    var state = Mutex(value: CombinedState<First, Second>())
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
