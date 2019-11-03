public extension ObservableType {
    func observeOn<Scheduler: KnownSchdulerType>(_ scheduler: Scheduler)
        -> Observable<Event, AsyncRunner<Scheduler>> {

        return Observable { [subscribe] handler in
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
}
