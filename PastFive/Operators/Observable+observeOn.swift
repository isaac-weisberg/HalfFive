public extension ObservableType {
    func observeOn<Scheduler: KnownSchdulerType>(_ scheduler: Scheduler)
        -> ScheduledObservable<Event, Scheduler> {

        return ScheduledObservable.unchecked(scheduler: scheduler, observeOnFactory(subscribe, scheduler))
    }
}

public extension ScheduledObservableType {
    func observeOn<Scheduler: KnownSchdulerType>(_ scheduler: Scheduler)
        -> ScheduledObservable<Event, Scheduler> {

        return ScheduledObservable.unchecked(scheduler: scheduler, observeOnFactory(subscribe, scheduler))
    }
}


private func observeOnFactory<Event, Scheduler: KnownSchdulerType>(
    _ subscribe: @escaping Subscribe<Event>,
    _ scheduler: Scheduler
) -> (@escaping (Event) -> Void) -> Disposable {
    return { handler in
        let disposable = DropInDisposable()

        disposable.nested = subscribe { event in
            scheduler.queue.async { [weak disposable] in
                guard disposable != nil else {
                    return
                }
                handler(event)
            }
        }

        return disposable
    }
}
