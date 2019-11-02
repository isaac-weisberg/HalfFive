public extension Single {
    func flatMap<NewEvent>(_ transform: @escaping (Event) -> Single<NewEvent, Error>) -> Single<NewEvent, Error> {
        let subscribe = self.subscribe
        return Single<NewEvent, Error> { observer in
            let disposable = DisposableDropIn()

            disposable.nested = subscribe { [weak disposable] event in
                guard let disposable = disposable else {
                    return
                }
                switch event {
                case .failure(let error):
                    disposable.nested = nil
                    observer(.failure(error))
                case .success(let success):
                    disposable.nested = transform(success)
                        .subscribe(observer)
                }
            }
            return disposable
        }
    }
}

