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
