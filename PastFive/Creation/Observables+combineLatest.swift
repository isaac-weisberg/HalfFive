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
        _ transform: @escaping (First.Event, Second.Event) -> Event
    ) -> Observable<Event> {

        return combineLatestUnsafe(first, second, Mutex.self, transform)
    }

    static func combineLatest
    <
        Event,
        First: ScheduledObservableType,
        Second: ScheduledObservableType
    >
    (
        _ first: First,
        _ second: Second,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    ) -> Observable<Event> {

        return combineLatestUnsafe(first.unscheduled, second.unscheduled, Mutex.self, transform)
    }

    static func combineLatest
    <
        Event,
        First: ScheduledObservableType,
        Second: ScheduledObservableType
    >
    (
        _ first: First,
        _ second: Second,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    ) -> Observable<Event>
    where First.Scheduler: SingleInstanceScheduler & SynchronizedScheduler, First.Scheduler == Second.Scheduler {

        return combineLatestUnsafe(first.unscheduled, second.unscheduled, MutexUnsafe.self, transform)
    }

    static func combineLatest
    <
        Event,
        First: ScheduledObservableType,
        Second: ScheduledObservableType
    >
    (
        _ first: First,
        _ second: Second,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    )
    -> ScheduledObservable<Event, First.Scheduler>
    where First.Scheduler == Second.Scheduler, First.Scheduler: ReproduceableScheduler & SynchronizedScheduler {

        if first.scheduler.queue === second.scheduler.queue {
            return combineLatestUnsafe(first.unscheduled, second.unscheduled, MutexUnsafe.self, transform)
                .promoteToScheduled(first.scheduler)
        }
        let synchronizationScheduler = First.Scheduler.instantiate()
        return combineLatestUnsafe(
            first.observeOn(synchronizationScheduler).unscheduled,
            second.observeOn(synchronizationScheduler).unscheduled,
            MutexUnsafe.self,
            transform)
        .promoteToScheduled(synchronizationScheduler)
    }

    static private func combineLatestUnsafe
    <
        Event,
        First: ObservableType,
        Second: ObservableType,
        Mutex: MutexType
    >
    (
        _ first: First,
        _ second: Second,
        _ mutexType: Mutex.Type,
        _ transform: @escaping (First.Event, Second.Event) -> Event
    )
    -> Observable<Event>
        where Mutex.Value == CombinedState<First.Event, Second.Event> {

        return Observable { handler in
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
