public struct Observable<Event>: ObservableType {
    static func unsafe(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) -> Self {
        return Self(factory)
    }

    let factory: (@escaping (Event) -> Void) -> Disposable

    public func subscribe(_ onNext: @escaping (Event) -> Void) -> Disposable {
        return factory(onNext)
    }

    private init(_ factory: @escaping (@escaping (Event) -> Void) -> Disposable) {
        self.factory = factory
    }
}
