public extension Single {
    func mapError<NewError>(_ transform: @escaping (Error) -> NewError) -> Single<Event, NewError> {
        let subscribe = self.subscribe
        return Single<Event, NewError> { observer in
            return subscribe { event in
                let newEvent = { () -> SingleEvent<Event, NewError> in
                    switch event {
                    case .success(let success):
                        return .success(success)
                    case .failure(let error):
                        return .failure(transform(error))
                    }
                }()
                observer(newEvent)
            }
        }
    }
}
