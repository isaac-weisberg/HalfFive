public extension Single {
    func flatMap<NewEvent, NewError>(_ transform: @escaping (SingleEvent<Event, Error>) -> Single<NewEvent, NewError>) -> Single<NewEvent, NewError> {
        let subscribe = self.subscribe
        return Single<NewEvent, NewError> { observer in
            let disposable = DisposableDropIn()

            disposable.nested = subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                disposable.nested = transform(event)
                    .subscribe(observer)
            }
            return disposable
        }
    }
}

