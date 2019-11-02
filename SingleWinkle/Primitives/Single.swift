public enum SingleEvent<Event, Error> {
    case success(Event)
    case failure(Error)
}

public struct Single<Event, Error> {
    public typealias Observer = (SingleEvent<Event, Error>) -> Void
    public typealias Factory = (@escaping Observer) -> Disposable

    let factory: Factory

    public init(_ factory: @escaping Factory) {
        self.factory = factory
    }

    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        return factory(observer)
    }
}

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
